# rojo-tools

A collection of [Lune](https://lune-org.github.io/docs) scripts for managing Roblox places with [Rojo](https://rojo.space). These scripts automate common workflows like building, serving, syncing back, and reverting Roblox places via the Open Cloud API.

## Installing Lune

[Rokit](https://github.com/rojo-rbx/rokit) is a toolchain manager for Roblox projects. Use it to install Lune:

1. **Install Rokit** (if you haven't already):

   ```sh
   curl -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash
   ```

2. **Add Lune to your project:**

   ```sh
   rokit add lune-org/lune
   ```

   This creates or updates a `rokit.toml` in your project with the Lune version pinned.

3. **Verify the installation:**

   ```sh
   lune --version
   ```

## Scripts

### `serve`

Starts a local development session. Ensures the rojo plugin is up to date, watches your project for sourcemap changes, and launches `rojo serve`.

```sh
lune run scripts/serve
```

### `build`

Builds the project into a `.rbxl` file using Rojo and publishes it to a selected Roblox place via the Open Cloud API. You will be prompted to choose which place to publish to.

```sh
lune run scripts/build
```

### `syncback`

Downloads a place from Roblox and syncs its contents back into the local filesystem using `rojo syncback`.  Will not run if `rojo serve` is currently active, as it could lead to files being duplicated.

```sh
lune run scripts/syncback
```

### `revert`

Rolls back a selected place to a previous version. Lists recent versions with timestamps and prompts for confirmation before reverting.

```sh
lune run scripts/revert
```

## Configuration

These scripts require an `OPEN_CLOUD_KEY` set in a `.env` file at the project root. The key needs the following permissions depending on the script:

| Script     | Required Permissions            |
| ---------- | ------------------------------- |
| `build`    | `universe-places:write`        |
| `syncback` | `legacy-asset:manage`          |
| `revert`   | `asset:read`, `asset:write`    |
