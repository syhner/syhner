import type { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open } from "./utils";

const FILE_NAME = `${__dirname}/../.config/karabiner/karabiner.json`;

const rules: KarabinerRules[] = [
  {
    description: "Hyper Key (caps lock -> ctrl + option + shift + command)",
    manipulators: [
      {
        type: "basic",
        description: "Caps Lock -> Hyper Key",
        from: { key_code: "caps_lock", modifiers: { optional: ["any"] } },
        to: [{ set_variable: { name: "hyper", value: 1 } }],
        to_after_key_up: [{ set_variable: { name: "hyper", value: 0 } }],
        to_if_alone: [{ key_code: "escape" }],
      },
    ],
  },
  {
    description: "Change left_shift + right_shift to caps_lock",
    manipulators: [
      {
        from: {
          key_code: "left_shift",
          modifiers: { mandatory: ["right_shift"], optional: ["caps_lock"] },
        },
        to: [{ key_code: "caps_lock" }],
        type: "basic",
      },
      {
        from: {
          key_code: "right_shift",
          modifiers: { mandatory: ["left_shift"], optional: ["caps_lock"] },
        },
        to: [{ key_code: "caps_lock" }],
        type: "basic",
      },
    ],
  },
  {
    description: "right_command -> left_control",
    manipulators: [
      {
        type: "basic",
        from: { key_code: "right_command", modifiers: { optional: ["any"] } },
        to: [{ key_code: "left_control" }],
      },
    ],
  },
  {
    description: "Change right_command+hjkl to arrow keys",
    manipulators: [
      {
        type: "basic",
        from: { key_code: "h", modifiers: { mandatory: ["left_control"], optional: ["any"] } },
        to: [{ key_code: "left_arrow" }],
      },
      {
        type: "basic",
        from: { key_code: "j", modifiers: { mandatory: ["left_control"], optional: ["any"] } },
        to: [{ key_code: "down_arrow" }],
      },
      {
        type: "basic",
        from: { key_code: "k", modifiers: { mandatory: ["left_control"], optional: ["any"] } },
        to: [{ key_code: "up_arrow" }],
      },
      {
        type: "basic",
        from: { key_code: "l", modifiers: { mandatory: ["left_control"], optional: ["any"] } },
        to: [{ key_code: "right_arrow" }],
      },
    ],
  },
  {
    description: "Change right_command + d/u to page down/up",
    manipulators: [
      {
        type: "basic",
        from: { key_code: "d", modifiers: { mandatory: ["left_control"], optional: ["any"] } },
        to: [{ key_code: "page_down" }],
      },
      {
        type: "basic",
        from: { key_code: "u", modifiers: { mandatory: ["left_control"], optional: ["any"] } },
        to: [{ key_code: "page_up" }],
      },
    ],
  },
  {
    description: "back / forward with mouse side buttons",
    manipulators: [
      {
        type: "basic",
        from: { pointing_button: "button4", modifiers: { optional: ["any"] } },
        to: [{ key_code: "open_bracket", modifiers: ["left_command"] }],
      },
      {
        type: "basic",
        from: { pointing_button: "button5", modifiers: { optional: ["any"] } },
        to: [{ key_code: "close_bracket", modifiers: ["left_command"] }],
      },
    ],
  },

  // Note: Avoid layers which use the same finger as the Hyper key (q, a, z)
  // Note: Avoid sub-layers which use the same finger as the layer
  ...createHyperSubLayers({
    // [B]rowse
    // a: AVOID
    b: {
      t: open("https://twitter.com"),
      y: open("https://news.ycombinator.com"),
    },
    // c: {},
    // d: {},
    // e: {},
    // f: {},
    // g: {},
    // h: {},
    // i: {},
    // [J]ump (via homerow.app) (requires homerow keybinds to be set)
    j: {
      // clic[K]
      k: {
        to: [{ key_code: "k", modifiers: ["right_command", "right_shift", "right_option"] }],
      },
      // scro[L]l
      l: {
        to: [{ key_code: "l", modifiers: ["right_command", "right_shift", "right_option"] }],
      },
      // [S]earch
      s: {
        to: [{ key_code: "s", modifiers: ["right_command", "right_shift", "right_option"] }],
      },
    },
    // k: {},
    // l: {},
    // m: {},
    // n: {},
    // [O]pen
    o: {
      b: app("Obsidian"), // O[B]sidian
      c: app("Cursor"), // [C]ursor
      d: app("Discord"), // [D]iscord
      e: app("Electron"), // [E]lectron
      f: app("Finder"), // [F]inder
      g: app("Ghostty"), // [G]hostty
      i: app("TickTick"), // T[I]ckTick
      k: app("Slack"), // Slac[K]
      m: app("Messages"), // [M]essages
      n: app("Notes"), // [N]otes
      p: app("Spotify"), // S[P]otify
      r: app("Reminders"), // [R]eminders
      s: app("Safari"), // [S]afari
      t: app("TablePlus"), // [T]ablePlus
      v: app("Cursor"), // [V]isual Studio Code
      w: app("Weather"), // [W]eather
      x: app("Proxyman"), // Pro[x]yman
      y: app("Yaak"), // [Y]aak
    },
    // p: {},
    // q: AVOID
    // [R]aycast
    r: {
      a: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
      c: open("raycast://extensions/thomas/color-picker/pick-color"),
      e: open("raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"),
      g: open("raycast://extensions/josephschmitt/gif-search/search"),
      h: open("raycast://extensions/raycast/clipboard-history/clipboard-history"),
      i: open("raycast://extensions/raycast/raycast/confetti"),
      k: open("raycast://extensions/mooxl/coffee/caffeinateWhile"),
      n: open("raycast://extensions/raycast/raycast-notes/raycast-notes"),
      m: open("raycast://extensions/raycast/navigation/search-menu-items"),
      p: open("raycast://extensions/raycast/clipboard-history/clipboard-history"),
      s: open("raycast://extensions/raycast/snippets/search-snippets"),
    },
    // s: {},
    // t: {},
    // u: {},
    // j: {},
    w: {
      // size
      d: {
        description: "Window: Hide",
        to: [{ key_code: "h", modifiers: ["right_command"] }],
      },
      hyphen: open("-g raycast://extensions/raycast/window-management/make-smaller"),
      equal_sign: open("-g raycast://extensions/raycast/window-management/make-larger"),

      // quadrants
      u: open("-g raycast://extensions/raycast/window-management/top-left-quarter"),
      i: open("-g raycast://extensions/raycast/window-management/top-right-quarter"),
      j: open("-g raycast://extensions/raycast/window-management/bottom-left-quarter"),
      k: open("-g raycast://extensions/raycast/window-management/bottom-right-quarter"),

      // halves
      h: open("-g raycast://extensions/raycast/window-management/left-half"),
      l: open("-g raycast://extensions/raycast/window-management/right-half"),

      // center
      c: open("-g raycast://extensions/raycast/window-management/center"),
      r: open("-g raycast://extensions/raycast/window-management/reasonable-size"),
      comma: open("-g raycast://extensions/raycast/window-management/almost-maximize"),
      m: open("-g raycast://extensions/raycast/window-management/maximize"),
      f: open("-g raycast://extensions/raycast/window-management/toggle-fullscreen"),

      // displays
      p: open("-g raycast://extensions/raycast/window-management/previous-display"),
      n: open("-g raycast://extensions/raycast/window-management/next-display"),
    },
    // x: {},
    // y: {},
    // z: AVOID
  }),
];

const contents = {
  global: { show_in_menu_bar: false },
  profiles: [
    {
      name: "Default",
      complex_modifications: {
        rules,
      },
    },
  ],
};

console.log("Generating karabiner config");

Bun.write(FILE_NAME, JSON.stringify(contents, null, 2));

console.log("Generated karabiner config");
