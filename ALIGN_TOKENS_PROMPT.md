# Task: Align this frontend's color scheme with the Capitec Stokvel MFE (design tokens only)

## Goal

Re-skin the appointment booking frontend at `~/Downloads/Appointment.Booking.System/frontend` so its
color scheme matches the Capitec Paragon design language used by the Stokvel microfrontend at
`~/Downloads/Capitec-local-repos/app-frontend_stokvel`.

**Scope is design tokens only.** Introduce a semantic token layer in Tailwind and repoint every
existing color utility class at it. Do **not** change layout, spacing, typography scale, component
structure, routing, business logic, or API code. No new dependencies. No new components.

## Why this is needed

The two apps currently look unrelated:

| | Stokvel MFE (source of truth) | This app (target) |
|---|---|---|
| Styling | MUI 5 + Emotion, theme injected at runtime | Tailwind CSS v4, utility classes |
| Brand color | Capitec **navy / blue** ramp | Capitec **red** (`bg-red-600`, 25 uses) |
| Neutrals | Blue-tinted surfaces (`#F0F3FA`, `#E3E8F2`) | Pure Tailwind grays (`gray-50`…`gray-900`) |
| Color access | Semantic tokens (`textHigh`, `surface.main`) | Raw palette classes (`text-gray-900`) |

After this task, this app should read as part of the same family: navy/blue brand, blue-tinted
neutral surfaces, and semantic token names instead of raw Tailwind palette classes.

**Important consequence to be aware of and to call out in your summary:** red stops being the brand
color and becomes *error-only*. Primary buttons, links, active nav, and focus rings all move from red
to navy/blue. This is intentional — it is what makes the app match Stokvel — but it is a large,
visible change, so verify screenshots before and after.

## Source of truth: what the Stokvel repo actually defines

Read these before you start:

- `~/Downloads/Capitec-local-repos/app-frontend_stokvel/src/App.tsx`
- `~/Downloads/Capitec-local-repos/app-frontend_stokvel/src/types/iconColors.ts`
- `~/Downloads/Capitec-local-repos/app-frontend_stokvel/package.json`

Findings you can rely on (already verified — no need to re-derive):

1. **Stokvel defines no palette of its own.** There is no theme, colors, palette, or tokens file in
   its `src`. `App.tsx:14` obtains the theme at runtime:
   ```ts
   import { useThemeFactory } from "@capitecbankltd/paragon_mfe_shared/theme/theme-factory-v2";
   const { theme } = useThemeFactory({ getContainerElement });
   ```
   and passes it to MUI's `ThemeProvider`. All hex values live in the shared Paragon package.

2. **The semantic token names Stokvel consumes** (these are the vocabulary to mirror):

   | Group | Tokens |
   |---|---|
   | Text | `text.textHigh`, `text.textMedium`, `text.textLow`, `text.secondary` |
   | Surface | `surface.main`, `surface.background`, `surface.backgroundDim`, `background.default` |
   | Brand | `primary.main`, `primary.light`, `primary.container`, `secondary.main`, `secondary.dark`, `accent.container` |
   | Semantic | `error.main`, `warning.light`, `success.main`, `info.light`, `disabled`, `action` |
   | Extended | `orange.dark`, `orange.deep`, `green.dark`, `common.white` |

   Usage frequency in Stokvel, which tells you which tokens carry the look: `textHigh` (119×),
   `textMedium` (59×), `surface.main` (19×), `primary` (18×), `surface.background` (15×),
   `textLow` (15×).

3. **The only hardcoded hex in Stokvel is inside SVG illustrations** (`src/assets/svg/*`) plus one
   `#4CAF50` in a dev `console.log`. `public/index.css` has no colors — only layout resets.

## Step 0 (do this first): get the exact hex values if you can

The exact Paragon hexes are **not** checked into the Stokvel repo, and its `node_modules` is not
installed. Try, in order, and stop at the first that works:

1. Check whether the package is already on disk anywhere:
   ```bash
   find ~ -type d -path "*@capitecbankltd/paragon_mfe_shared*" -not -path "*/.git/*" 2>/dev/null | head
   ```
   If found, read `theme/theme-factory-v2*` and any palette/token module it imports, and extract the
   real values for the token list above.

2. If not on disk, try installing it in the Stokvel repo (needs access to Capitec's private npm
   registry — it may fail, that is fine, do not spend long on it):
   ```bash
   cd ~/Downloads/Capitec-local-repos/app-frontend_stokvel && npm install --ignore-scripts
   ```

3. If neither works, use the fallback palette below and **state clearly in your summary that the
   values are inferred, not authoritative**, so they can be corrected later from the real package.

## Fallback palette (inferred — use only if Step 0 fails)

Derived from the hex values embedded in Stokvel's SVG illustrations, cross-checked against
`~/Downloads/Capitec-local-repos/app-frontend_mobile-ui/src/resources`. Treat the *ramp* as reliable
and the *token assignments* as a reasonable first pass.

Brand navy/blue ramp:

| Role | Hex |
|---|---|
| navy deepest | `#001E68` |
| navy | `#0033A0` |
| blue 700 | `#2259D0` |
| blue 600 (primary main) | `#2F70EF` |
| blue 500 | `#437FFF` |
| blue 400 | `#6B99FA` |
| blue 300 | `#82AAFF` |
| blue 200 | `#ACC7FF` |
| blue 100 (primary container) | `#BACEFF` |

Blue-tinted neutrals:

| Role | Hex |
|---|---|
| surface background | `#F0F3FA` |
| surface main | `#FFFFFF` |
| surface background dim | `#E3E8F2` |
| border / divider | `#C4CEE1` |
| muted / disabled | `#A6B6D1` |
| muted darker | `#92A4C4` |

Text:

| Token | Hex |
|---|---|
| `textHigh` | `#001E68` |
| `textMedium` | `#4E6066` |
| `textLow` | `#A6B6D1` |

Semantic:

| Token | Hex |
|---|---|
| `error.main` | `#E61414` |
| `success.main` | `#009243` |
| `warning` / `orange.dark` | `#FC8628` |
| `orange.deep` | `#C33B00` |
| `info` | `#009DE0` |
| `secondary` / teal | `#00486D` |

## What to implement

### 1. Define the token layer in `src/index.css`

This repo is Tailwind v4 (`@import "tailwindcss";` is currently the entire file — `src/App.css` is an
empty placeholder comment). Use a v4 `@theme` block so the tokens become real Tailwind utilities.
Name them after the Paragon semantics, not after hues, so the mapping to Stokvel stays legible:

```css
@import "tailwindcss";

@theme {
  /* brand */
  --color-primary: #2F70EF;
  --color-primary-dark: #001E68;
  --color-primary-light: #6B99FA;
  --color-primary-container: #BACEFF;
  --color-secondary: #00486D;

  /* surfaces */
  --color-surface: #FFFFFF;
  --color-surface-background: #F0F3FA;
  --color-surface-dim: #E3E8F2;
  --color-outline: #C4CEE1;

  /* text */
  --color-text-high: #001E68;
  --color-text-medium: #4E6066;
  --color-text-low: #A6B6D1;

  /* semantic */
  --color-error: #E61414;
  --color-success: #009243;
  --color-warning: #FC8628;
  --color-info: #009DE0;
  --color-disabled: #A6B6D1;
}
```

Adjust names/values to whatever Step 0 yielded. Add a short comment at the top of the block recording
where the values came from (Paragon package path, or "inferred — see ALIGN_TOKENS_PROMPT.md").

### 2. Repoint every existing color utility

Audit before you edit so you can prove full coverage:

```bash
cd ~/Downloads/Appointment.Booking.System/frontend && grep -rhoE '\b(bg|text|border|ring|from|to|via|fill|stroke|divide|placeholder|accent|shadow)-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose|white|black)(-[0-9]{1,3})?\b' src --include="*.tsx" --include="*.ts" | sort | uniq -c | sort -rn
```

Apply this mapping (counts are from the current audit — use them as a checklist):

| Current | Count | Replace with | Rationale |
|---|---|---|---|
| `bg-red-600`, `bg-red-700` | 25, 9 | `bg-primary`, `bg-primary-dark` | brand action → navy/blue |
| `text-red-600` (as brand/link) | 15 | `text-primary` | brand text |
| `text-red-600` (as validation) | — | `text-error` | keep genuine errors red |
| `ring-red-500`, `border-red-500` | 14, 3 | `ring-primary`, `border-primary` (focus) / `ring-error`, `border-error` (invalid) | **disambiguate by context** |
| `bg-red-50`, `bg-red-100`, `border-red-200` | 14, 2, 6 | `bg-primary-container/30` or `bg-error/10` | tinted panels vs error banners |
| `via-red-500`, `to-red-400`, `text-red-100/400` | 1 each | primary equivalents | hero gradient |
| `text-gray-900` | 31 | `text-text-high` | headings |
| `text-gray-700`, `text-gray-600`, `text-gray-500` | 15, 10, 35 | `text-text-medium` | body / secondary |
| `text-gray-400`, `text-gray-300` | 23, 6 | `text-text-low` | hints, placeholders, empty states |
| `bg-white` | 31 | `bg-surface` | cards |
| `bg-gray-50`, `bg-gray-100` | 18, 8 | `bg-surface-background`, `bg-surface-dim` | page + subtle fills |
| `border-gray-100`, `-200`, `-300` | 22, 19, 10 | `border-outline` | one divider color |
| `bg-green-*`, `text-green-*` | 4+2+3+2+2 | `bg-success/10`, `text-success` | status chips |
| `bg-amber-*`, `text-amber-800` | 3+2, 3 | `bg-warning/10`, `text-warning` | pending states |
| `bg-blue-100`, `text-blue-700/800` | 3, 2+2 | `bg-info/10`, `text-info` | info chips |
| `bg-purple-*`, `text-purple-*` | 3, 2+1+1 | `bg-primary-container`, `text-primary-dark` | collapse into brand |
| `text-white`, `border-white` | 30, 2 | keep as-is | still correct on brand fills |
| `bg-gray-800`, `bg-gray-200`, `bg-gray-300` | 2, 4, 2 | `bg-text-high`, `bg-surface-dim`, `bg-outline` | tooltips, skeletons, tracks |

The two `ring-red-500` / `border-red-500` rows are the only judgement calls: read each occurrence and
decide whether it is a **focus ring** (→ primary) or a **validation state** (→ error). Do not
mechanically replace those.

### 3. Files to work through

All under `~/Downloads/Appointment.Booking.System/frontend/src`:

- `index.css` — token definitions (the only file that gains new content)
- `components/Layout.tsx` — app shell, nav, header
- `components/ui/StatCard.tsx`, `ui/ConfirmModal.tsx`, `ui/Skeleton.tsx`
- `components/ErrorBoundary.tsx`
- `context/ToastContext.tsx` — toast variants map to error/success/warning/info
- `pages/HomePage.tsx`, `BookingPage.tsx`, `AppointmentsPage.tsx`, `BranchesPage.tsx`,
  `AdminPage.tsx`, `LoginPage.tsx`, `RegisterPage.tsx`
- `App.css` — leave alone unless it stops being empty

Do not touch `src/services/**`, `src/types/**`, `src/context/authContext.ts`, `useAuth.ts`,
`tokenStore.ts`, `vite.config.ts`, or `package.json`.

## Constraints

- **Tokens only.** No layout, spacing, radius, font-size, shadow, or component-structure changes.
  If a component looks wrong after re-skinning, note it in your summary rather than restructuring it.
- **No new dependencies.** No MUI, no Emotion, no `@capitecbankltd/*` package in this repo — the
  point is to *match* Paragon's colors in Tailwind, not to import Paragon.
- **No leftover raw palette classes.** After the change, the audit command in step 2 should return
  only `text-white` / `border-white` (and `black` if genuinely needed). Everything else must be a
  token class.
- **Tests must stay green.** Several tests in `src/test/` assert on rendered output; a few may assert
  on class names. If a test breaks, fix the *test's* color expectation — do not weaken an assertion
  or change component behaviour to satisfy it.
- **Accessibility.** Every text/background pairing you introduce must clear WCAG AA (4.5:1 for body
  text, 3:1 for large text). `text-text-low` (`#A6B6D1`) on white is roughly 2:1 — use it only for
  decorative or disabled content, never for meaningful body copy. Check `text-white` on
  `bg-primary` (`#2F70EF`) and flag it if it falls short; `bg-primary-dark` is the safe alternative.

## Verification

1. `npx tsc --noEmit` (or the repo's build) passes.
2. `npm run lint` passes.
3. `npm test` — all tests pass; report any test file you had to update and why.
4. `npm run build` succeeds.
5. Run the dev server and screenshot Home, Login, Booking, Appointments, and Admin. Confirm: navy/blue
   brand, blue-tinted page background, red present only on genuine errors.
6. Re-run the audit grep from step 2 and paste the (near-empty) output as proof of coverage.

## Deliverables

- The code changes.
- A short summary listing: which Step 0 path succeeded (real Paragon values vs inferred fallback), the
  final token table you settled on, any occurrence where the focus-ring vs validation-state call was
  ambiguous and how you decided, any contrast pairing that failed AA, and anything that now looks
  visually off and would need a follow-up beyond token scope.
