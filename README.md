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

### 4. Lightroom Integration (The "Monitor" Method)

Since Lightroom's "Publish Service" is limited, we use a smarter approach: **A Monitoring Script**.

#### Option A: Run manually
Open a terminal and run this command. (Requires window to stay open):
```bash
./watch.sh
```

#### Option B: Run in Background (Set and Forget)
Install the script as a system service so it runs automatically when you log in!
```bash
./install_service.sh
```
*   **Logs**: Check `logs/watcher.log` to see it working.
*   **Restart**: If you reboot, it starts itself.

---

**In Lightroom**:
- Just **Export** your photos normally to `src/content/portfolio/[CollectionName]`.
- The script detects the new files, waits 2 seconds, and auto-deploys.

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

### 🔐 Multi-Computer Path Fix (User Alias)
If your username is different on each computer (e.g. `leo` vs `LeoWuellner`), Lightroom will get confused.
You can fix this by "aliasing" the username so both paths exist on both computers.

**On computer A (User: `leo`):**
Run this to make `/Users/LeoWuellner` point to your actual home:
```bash
sudo ln -s /Users/leo /Users/LeoWuellner
```

**On computer B (User: `LeoWuellner`):**
Run this to make `/Users/leo` point to your actual home:
```bash
sudo ln -s /Users/LeoWuellner /Users/leo
```

**Result:**
You can now use `/Users/leo/Code/portfolio` OR `/Users/LeoWuellner/Code/portfolio` interchangeably on EITHER machine, and they will always work!
Update Lightroom to use one of them (pick one and stick to it), and it will sync perfectly.

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
