# Leo Wuellner Portfolio

A minimalist photography portfolio built with [Astro](https://astro.build) and [Tailwind CSS](https://tailwindcss.com).

## 🚀 Deployment & Automation

This project is configured for fully automated deployment.

### 1. GitHub
The source code is hosted at:
**[https://github.com/TheRealLaw/portfolio](https://github.com/TheRealLaw/portfolio)**

### 2. Vercel Automation
Vercel is connected to the GitHub repository.
- **Trigger**: Any push to the `main` branch.
- **Action**: Vercel automatically builds and deploys the site live.

### 3. How to Update the Site
The easiest way to publish changes (new photos, text updates, etc.) is using the included script.

1. **Make Changes**:
   - Add new collection folders to `src/content/portfolio/`.
   - Edit text in files like `src/pages/bio.astro`.
   
2. **Run the Publish Script**:
   Open your terminal in the project folder and run:
   ```bash
   ./publish.sh
   ```
   
   **What `publish.sh` does:**
   1. Adds all new files/changes.
   2. Commits them with a current timestamp.
   3. Pushes to GitHub.
   4. **Which triggers Vercel to update your live site.**

### 4. Lightroom Classic Integration
You can trigger updates directly from Lightroom!

**One-Time Setup:**
1.  Open Lightroom Classic -> **Publish Services** (bottom left).
2.  Click `+` -> **Go to Publishing Manager**.
3.  Add "Hard Drive" service. Name it "Web Portfolio".
4.  **Export Location**: `.../leowuellner.com/src/content/portfolio`
5.  **Image Sizing**: Resize to Fit -> Long Edge -> 2500 pixels.
6.  **Post-Process Actions**:
    - "After Export": Select "Open Application..."
    - Browse and select your `publish.sh` file: `/Users/leo/Code/leowuellner.com/publish.sh`

**To Publish:**
1.  Right-click "Web Portfolio".
2.  Create a **Published Collection** (e.g., "Tokyo").
3.  Drag photos in.
4.  Click **Publish**. (This will export images + run the script to deploy).

---

## 🔄 Multi-Computer Workflow

To prevent out-of-sync issues when using multiple computers (e.g., Desktop & Laptop):

1.  **Before starting work**:
    Run the sync script to pull the latest changes from GitHub.
    ```bash
    ./sync.sh
    ```
2.  **Publishing**:
    The `./publish.sh` script now automatically pulls changes before pushing, but it's best practice to run `sync.sh` first if you know you made changes elsewhere.

---

## 🛠 Local Development (New Computer Setup)

If you are setting this up on a new Mac:

1.  **Clone the Repo**:
    ```bash
    git clone https://github.com/TheRealLaw/portfolio.git
    cd portfolio
    ```
2.  **Run Setup Script**:
    This handles all dependencies (Node.js, Git, etc.).
    ```bash
    ./setup.sh
    ```
3.  **Start Dev Server**:
    ```bash
    npm run dev
    ```

Visit `http://localhost:4321` to view the site.

## 📁 Project Structure

- `src/content/portfolio/`: **Photo Collections**. Each folder here becomes a gallery.
  - Must contain images.
  - Should have a `cover.jpg` (or png/webp) for the homepage thumbnail.
- `src/pages/`:
  - `index.astro`: The Homepage (grid of collections).
  - `bio.astro`: The Biography page.
  - `portfolio/[slug].astro`: The dynamic gallery view for each collection.
- `src/components/`:
  - `Header.astro`: Top navigation bar.
  - `Lightbox.astro`: PhotoSwipe integration logic.
