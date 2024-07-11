/* See LICENSE file for copyright and license details. */

#include <X11/X.h>
#include <X11/XF86keysym.h>
#include "colors.h"
#include "version.h"

#define TERMINAL "kitty"
#define TERMCLASS "kitty"

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int horizpadbar        = 10;        /* horizontal padding for statusbar */
static const int vertpadbar         = 10;        /* vertical padding for statusbar */

static const unsigned int stairpx   = 20;       /* depth of the stairs layout */
static const int stairdirection     = 1;        /* 0: left-aligned, 1: right-aligned */
static const int stairsamesize      = 1;        /* 1 means shrink all the staired windows to the same size */
static const char panel[][20]       = { "xfce4-panel", "Xfce4-panel" }; /* name & cls of panel win */

static const char *fonts[]          = { "JetBrains Mono Nerd Font:size=15", "Noto Color Emoji:size=15" };
static const char dmenufont[]       = { "JetBrains Mono Nerd Font:size=15" };


static const char *colors[][4]      = {
	                   /*   fg             bg            border       marker      */
	[SchemeNorm]     = { nfgcolor,      nbgcolor,       nbcolor,    nmarkcolor    },
	[SchemeSel]      = { selfgcolor,    selbgcolor,     selbcolor,  selmarkcolor  },
	[SchemeUrg]      = { urgfgcolor,    urgbgcolor,     urgbcolor,  urgmarkcolor  },
	[SchemeStatus]   = { sfgcolor,      sbgcolor,       sbcolor,    smarkcolor    }, // Statusbar right {text,background,not used but cannot be empty}
	[SchemeTagsNorm] = { tnfgcolor,     tnbgcolor,      tnbcolor,   tnmarkcolor   }, // Tagbar left unselected {text,background,not used but cannot be empty}
	[SchemeTagsSel]  = { tselfgcolor,   tselbgcolor,    tselbcolor, tselmarkcolor }, // Tagbar left selected {text,background,not used but cannot be empty}
	[SchemeInfoNorm] = { infgcolor,     inbgcolor,      inbcolor,   inmarkcolor   }, // infobar middle  unselected {text,background,not used but cannot be empty}
	[SchemeInfoSel]  = { iselfgcolor,   iselbgcolor,    iselbcolor, iselmarkcolor }, // infobar middle  selected {text,background,not used but cannot be empty}
};

static const XPoint stickyicon[]    = { {0,0}, {4,0}, {4,8}, {2,6}, {0,8}, {0,0} }; /* represents the icon as an array of vertices */
static const XPoint stickyiconbb    = {4,8};	/* defines the bottom right corner of the polygon's bounding box (speeds up scaling) */

typedef struct {
	const char *name;
	const void *cmd;
} Sp;

const char *spcmd1[] = {"kitty", "--name", "kittyterm", "-T", "scratch", "-o", "initial_window_width=300", "-o", "initial_window_height=200", NULL };
const char *spcmd2[] = {"keepassxc", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"kitterterm",  spcmd1},
	{"keepassxc",   spcmd2},
};

/* tagging */
static const char *tags[] = { "", "", "󱛕", "", "", "", "󰘂 ", "󰕼", "" };
static const char *tagsalt[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
static const int momentaryalttags = 1; /* 1 means alttags will show only when key is held down*/

static const char *defaulttagapps[] = { NULL, "kitty", NULL, NULL, NULL, NULL, NULL, NULL, "keepassxc" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating  isterminal  noswallow    monitor */
	{ "Firefox",  NULL,         NULL,       1,              0,           0,         0,         -1 },
    { TERMCLASS,  NULL,         NULL,       0,              0,           1,         0,         -1 },
    { NULL,		  "kittyterm",  "scratch",  SPTAG(0),		1,			 1,         0,         -1 },
    { NULL,		  "keepassxc",	NULL,		SPTAG(1),		0,			 0,         0,         -1 },
	{ panel[1],   NULL,         NULL,       (1 << 9) - 1,   1,           0,         0,         -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 0; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "",      tile },    /* first entry is default */
	{ "󰍉",      monocle },
	{ "",      bstack },
	{ "",      bstackhoriz },
    { "󰋁",      gaplessgrid },
    { "󰓍",      stairs },
};

/* key definitions */
#define MODKEY Mod4Mask
#define HOLDKEY 0xffeb
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define STACKKEYS(MOD,ACTION) \
{ MOD,XK_j,ACTION##stack,{.i = INC(+1) } }, \
{ MOD,XK_k,ACTION##stack,{.i = INC(-1) } }, \
{ MOD,  XK_v,   ACTION##stack,  {.i = 0 } }, \

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
#ifdef DESKTOP
static const char *dmenucmd[] =                { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", dmenubgcolor, "-nf", dmenufgcolor, "-sb", dmenuselbgcolor, "-sf", dmenuselfgcolor, NULL };
#endif
#ifdef LAPTOP
static const char *dmenucmd[] =                 { "j4-dmenu-desktop --dmenu=\"dmenu -i -y 250 -x 760 -dim 0.25 -h 50 -w 400 -nb \\#3d056b -nf \\#df00e3 -sf \\#02fa1f -l 10 -fn \"Droid Sans Mono-30\"\"", NULL };
#endif
static const char *termcmd[]  =                 { "kitty", NULL };
static const char *browsercmd[]  =              { "firefox", NULL };
static const char *shutdowncmd[]  =             { "shutdown", "now", NULL };
static const char *screenshotcmd[]  =           { "scrot", NULL };
static const char *screenshotpartialcmd[]  =    { "scrot", "-f", "-s", NULL };


static const char *upvol[]     = { "pactl", "set-sink-volume",  "1", "+5%", NULL };
static const char *downvol[]   = { "pactl", "set-sink-volume",  "1", "-5%", NULL };
static const char *mutevol[]   = { "pactl", "set-sink-mute",    "1", "toggle", NULL };

#ifdef LAPTOP
static const char *uplight[]   = { "backlight_control", "+10", NULL };
static const char *downlight[] = { "backlight_control", "-10", NULL };
#endif

static const char **startup_programs[] = { browsercmd };

static const Key keys[] = {
    /* modifier                     key        function        argument */
    { 0,                            XF86XK_AudioLowerVolume,  spawn, {.v = downvol}   },
    { 0,                            XF86XK_AudioRaiseVolume,  spawn, {.v = upvol}     },
    { 0,                            XF86XK_AudioMute,         spawn, {.v = mutevol}   },
#ifdef LAPTOP
    { 0,                            XF86XK_MonBrightnessUp,   spawn, {.v = uplight}   },
    { 0,                            XF86XK_MonBrightnessDown, spawn, {.v = downlight} },
#endif
    { MODKEY,                       XK_d,           spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return,      spawn,          {.v = termcmd } },
    { MODKEY|ShiftMask,             XK_s,           spawndefault,   {0} },
    { MODKEY|ShiftMask,             XK_f,           spawn,          {.v = browsercmd } },
    { 0,                            XK_Print,       spawn,          {.v = screenshotcmd } },
    { ShiftMask,                    XK_Print,       spawn,          {.v = screenshotpartialcmd } },
    { MODKEY|ShiftMask,             XK_h,           setmfact,       {.f = -0.05} },
    { MODKEY|ShiftMask,             XK_l,           setmfact,       {.f = +0.05} },
    { MODKEY|ShiftMask,             XK_j,           setcfact,       {.f = +0.25} },
    { MODKEY|ShiftMask,             XK_k,           setcfact,       {.f = -0.25} },

    { MODKEY,                       XK_t,           setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_f,           setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_p,           setlayout,      {.v = &layouts[2]} },
    { MODKEY|ShiftMask,             XK_p,           setlayout,      {.v = &layouts[3]} },
    { MODKEY,                       XK_g,           setlayout,      {.v = &layouts[4] } },
    { MODKEY|ShiftMask,             XK_g,           setlayout,      {.v = &layouts[5]} },

    { MODKEY,                       XK_space,       focusmaster,    {0} },
    { MODKEY,                       XK_j,           focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,           focusstack,     {.i = -1 } },
    { MODKEY|ShiftMask,             XK_i,           incnmaster,     {.i = +1 } },
    { MODKEY|ShiftMask,             XK_d,           incnmaster,     {.i = -1 } },
    { MODKEY|ShiftMask,             XK_space,       zoom,           {0} },

#ifdef DESKTOP
    { MODKEY,                       XK_comma,       focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period,      focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,       tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period,      tagmon,         {.i = +1 } },
#endif

    { MODKEY,                       XK_c,           movecenter,     {0} },
    { MODKEY,                       XK_0,           view,           {.ui = ~0 } },
    { MODKEY,                       XK_Tab,         view,           {0} },
    { MODKEY|ShiftMask,             XK_0,           tag,            {.ui = ~0 } },
    { MODKEY|ControlMask,           XK_space,       togglefloating, {0} },
    { MODKEY,                       XK_s,           togglesticky,   {0} },
    { MODKEY,                       XK_b,           togglebar,      {0} },
    { 0,                            HOLDKEY,        togglealttag,   {0} },
    { MODKEY,            			XK_y,  	        togglescratch,  {.ui = 0 } },
    { MODKEY|ShiftMask,             XK_y,  	        togglescratch,  {.ui = 1 } },
    { MODKEY,                       XK_semicolon,   togglemark,     {0} },
    { MODKEY,                       XK_o,           swapfocus,      {0} },
    { MODKEY,                       XK_u,           swapclient,     {0} },
    { MODKEY,                       XK_q,           killclient,     {0} },
    { MODKEY|ShiftMask,             XK_q,           quit,           {0} },
    { MODKEY|ShiftMask|ControlMask, XK_q,           spawn,          {.v = shutdowncmd } },
    TAGKEYS(                    XK_1,                           0)
        TAGKEYS(                    XK_2,                           1)
        TAGKEYS(                    XK_3,                           2)
        TAGKEYS(                    XK_4,                           3)
        TAGKEYS(                    XK_5,                           4)
        TAGKEYS(                    XK_6,                           5)
        TAGKEYS(                    XK_7,                           6)
        TAGKEYS(                    XK_8,                           7)
        TAGKEYS(                    XK_9,                           8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button1,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
