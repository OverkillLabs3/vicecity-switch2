// Switch 2 support code for reVC. It is kept apart from the game's headers because the libnx types clash with the game's own.
#ifdef __SWITCH__
#ifndef __SWITCH2__
#define __SWITCH2__ 1
#endif
#include <switch.h>
#include <SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// declared by libounce under __SWITCH2__, which the compile flags of this target do not always define
extern "C" Result nwindowSetFrameRates(NWindow* nw, u32 fps_at_120hz, u32 fps_at_60hz, bool vrr);

#define DATA_DIR "sdmc:/switch/gtavc"

bool SwitchShowFps = false;

void SwitchEarlyInit(void)
{
	// a fixed 1920x1080 surface in handheld and docked mode, the system scales it on a TV
	nwindowSetDimensions(nwindowGetDefault(), 1920, 1080);
	chdir(DATA_DIR);
	freopen(DATA_DIR "/log.txt", "w", stdout);
	freopen(DATA_DIR "/log.txt", "a", stderr);
	setvbuf(stdout, NULL, _IONBF, 0);
	setvbuf(stderr, NULL, _IONBF, 0);

	// the FPS counter choice is kept as a file
	SwitchShowFps = access(DATA_DIR "/fps_on", F_OK) == 0;
}

void SwitchToggleFps(void)
{
	SwitchShowFps = !SwitchShowFps;
	if (SwitchShowFps) {
		FILE *f = fopen(DATA_DIR "/fps_on", "w");
		if (f) {
			fclose(f);
		}
	} else {
		remove(DATA_DIR "/fps_on");
	}
}

// true on the first start only: the highest graphics settings are applied once and then belong to the player
bool SwitchGraphicsNeedSetup(void)
{
	if (access(DATA_DIR "/graphics_done", F_OK) == 0) {
		return false;
	}
	FILE *f = fopen(DATA_DIR "/graphics_done", "w");
	if (f) {
		fclose(f);
	}
	return true;
}

// Asks the display for its highest refresh rate. Setting a swap interval withdraws the request, so librw calls this after it.
extern "C" void switch_s2_set_frame_rates(void)
{
	nwindowSetFrameRates(nwindowGetDefault(), 0, 0, true);
}

// Joy-Con 2 mouse: the PadPointer of libounce follows a Joy-Con that slides over a surface. It is fed to SDL as mouse events.
static PadState ptr_pad;
static PadPointer ptr_state;
static int ptr_ok; // 0 not tried, 1 working, -1 not available
static unsigned ptr_old_buttons;
static unsigned ptr_cur_buttons;
static int ptr_old_x = -1, ptr_old_y = -1;

// 0: the pointer is not in use, 1: a left Joy-Con is the mouse, 2: a right one
int SwitchPointerSide(void)
{
	if (ptr_ok <= 0 || !ptr_state.active) {
		return 0;
	}
	return (int)ptr_state.side;
}

int SwitchPointerMouseState(void)
{
	return ((ptr_cur_buttons & 1) ? SDL_BUTTON(1) : 0) | ((ptr_cur_buttons & 2) ? SDL_BUTTON(3) : 0);
}

void SwitchPointerPoll(void)
{
	if (ptr_ok == 0) {
		padInitializeAny(&ptr_pad);
		ptr_ok = R_SUCCEEDED(padPointerInitialize(&ptr_state, 1920, 1080)) ? 1 : -1;
	}
	if (ptr_ok < 0) {
		return;
	}

	padUpdate(&ptr_pad);
	padPointerUpdate(&ptr_state, &ptr_pad);
	if (!ptr_state.active) {
		ptr_cur_buttons = 0;
		ptr_old_buttons = 0;
		ptr_old_x = ptr_old_y = -1;
		return;
	}

	int x = ptr_state.x, y = ptr_state.y;
	unsigned b = padPointerGetButtons(&ptr_state);
	ptr_cur_buttons = b;
	SDL_Event m;

	if (x != ptr_old_x || y != ptr_old_y || ptr_state.delta_x != 0 || ptr_state.delta_y != 0) {
		SDL_zero(m);
		m.type = SDL_MOUSEMOTION;
		m.motion.state = ((b & 1) ? SDL_BUTTON_LMASK : 0) | ((b & 2) ? SDL_BUTTON_RMASK : 0);
		m.motion.x = x;
		m.motion.y = y;
		m.motion.xrel = ptr_state.delta_x;
		m.motion.yrel = ptr_state.delta_y;
		SDL_PushEvent(&m);
		ptr_old_x = x;
		ptr_old_y = y;
	}

	unsigned changed = b ^ ptr_old_buttons;
	for (int bit = 0; bit < 2; bit++) {
		if (changed & (1u << bit)) {
			SDL_zero(m);
			m.type = (b & (1u << bit)) ? SDL_MOUSEBUTTONDOWN : SDL_MOUSEBUTTONUP;
			m.button.button = bit == 0 ? SDL_BUTTON_LEFT : SDL_BUTTON_RIGHT;
			m.button.state = (b & (1u << bit)) ? SDL_PRESSED : SDL_RELEASED;
			m.button.clicks = 1;
			m.button.x = x;
			m.button.y = y;
			SDL_PushEvent(&m);
		}
	}
	ptr_old_buttons = b;
}
#endif
