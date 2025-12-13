# Product Requirements Document: "GroundGlass" Portfolio Site

## 1. Project Overview
**Goal:** Build a maintainable, collection-based photography portfolio similar in structure to [Reference Site](https://lwuellner2029.wixsite.com/my-site-2/portfolio).
**Core Workflow:** User exports folders from Lightroom (e.g., "Tokyo", "Yosemite") to local directories. The site auto-generates category cards.
**Target Audience:** Minimalist photographers requiring organization by Location/Trip.

## 2. Tech Stack
* **Framework:** Astro (Latest) - Zero-JS by default.
* **Styling:** Tailwind CSS.
* **Language:** TypeScript.
* **Animation:** `framer-motion` (optional, for smooth page transitions) or standard CSS transitions.

## 3. Data & Content Structure (Crucial Update)
We will use file-system routing to create collections automatically.

**Directory Structure:**
```text
/
├── src/
│   ├── content/
│   │   ├── portfolio/           <-- Content Collections
│   │   │   ├── tokyo/           <-- Collection Name = Folder Name
│   │   │   │   ├── cover.jpg    <-- Used for the Grid Card on Homepage
│   │   │   │   ├── img1.jpg
│   │   │   │   └── img2.jpg
│   │   │   ├── yosemite/
│   │   │   │   ├── cover.jpg
│   │   │   │   └── img1.jpg
│   └── ...
```

## 4. Functional Requirements

### A. Global Navigation (Sidebar or Top-Left)
* **Style:** Sticky sidebar on Desktop, Hamburger on Mobile (matching the reference).
* **Links:**
    * **Home/Portfolio:** Grid of Collections (Tokyo, Kyoto, etc.).
    * **Top 20 Shots:** A special curated "Best Of" gallery.
    * **Bio:** Simple text page.
* **Behavior:** Active state highlighting.

### B. Homepage (Collections Grid)
* **Visual:** A clean grid of "Cards".
* **Card Content:**
    * Square or 4:3 aspect ratio thumbnail (using `cover.jpg` from the folder).
    * Collection Title overlay or text below (e.g., "TOKYO").
* **Interaction:** Clicking a card navigates to `/portfolio/[collection-slug]`.

### C. Collection Detail Page (The Gallery)
* **Route:** `/portfolio/[slug]` (e.g., `/portfolio/tokyo`).
* **Layout:** Masonry or Justified Grid of all images in that folder.
* **Lightbox:** Clicking an image opens it full screen with arrow navigation.

## 5. Implementation Steps for AI
1.  **Content Loader:** Create a utility to scan `src/content/portfolio/*`. treat every subfolder as a "Collection".
2.  **Dynamic Routing:** Create `src/pages/portfolio/[collection].astro` to render specific folders.
3.  **Image Optimization:** Use `astro:assets` `<Image />` component. Ensure `cover.jpg` is used specifically for thumbnails.
4.  **Sidebar Component:** Create a recursive menu component that lists all collections found in the folder structure.

## 6. Design Aesthetic
* **Reference:** Clean, white/neutral background.
* **Fonts:** Simple Sans-Serif (Inter or System UI).
* **Grid:** Strict alignment. 3 columns on Desktop, 1 column on Mobile.
* **Hover Effects:** Slight opacity drop or scale-up on cover images when hovered.