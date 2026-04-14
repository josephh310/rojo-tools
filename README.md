# rojo-tools

A collection of [Lune](https://lune-org.github.io/docs) scripts for managing Roblox places with [Rojo](https://rojo.space). These scripts automate common workflows like building, serving, syncing back, and reverting Roblox places via the Open Cloud API.

## Recommended Usage

Each team member should have their own place under the game to work in. The typical workflow for a feature looks like this:

1. **Pull from main** and run `build` to publish the latest code to your personal place.
2. **Run `serve`** to sync scripts to Studio while you edit them locally.
3. When you need to edit the map or assets in Studio, **stop `serve` first**, make your changes, then run `syncback` to pull those changes back into the filesystem.
4. Once your feature is complete, **pull from main again** and test the game to make sure everything works together before opening a pull request.

Only stable, tested versions should be published to the main place. If you want an extra layer of safety, use a staging place instead of publishing directly to the main place to avoid accidentally shipping an update.

Assets like the map and UI should be created separately by the responsible developers in their own places, then synced into the repository by someone with access.

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

3. **Add Rojo to your project** (version 7.7.0-rc.1 or above):

   ```sh
   rokit add rojo-rbx/rojo@7.7.0-rc.1
   ```

4. **Install all tools:**

   ```sh
   rokit install
   ```

5. **Verify the installation:**

   ```sh
   lune --version
   ```


## Configuration

These scripts require an `OPEN_CLOUD_KEY` set in a `.env` file at the project root. __Every team member should have their own key__. The key needs the following permissions depending on the script:

| Script     | Required Permissions            |
| ---------- | ------------------------------- |
| `build`    | `universe-places:write`        |
| `syncback` | `legacy-asset:manage`          |
| `revert`   | `asset:read`, `asset:write`    |

## Acknowledgements

Thank you to the [Rojo](https://rojo.space) and [Lune](https://lune-org.github.io/docs) teams for building the tools that make this workflow possible.

## Example Project File

Here's an example `default.project.json` to get started with. Adapt the services, paths, and properties to fit your game.

```json
{
  "name": "My Game",
  "tree": {
    "$className": "DataModel",
    "Lighting": {
      "$path": "build/Lighting"
    },
    "MaterialService": {
      "$path": "build/MaterialService"
    },
    "ReplicatedFirst": {
      "Client": {
        "$path": "src/Client"
      },
      "$path": "src/ReplicatedFirst"
    },
    "ReplicatedStorage": {
      "Packages": {
        "$path": "Packages"
      },
      "Shared": {
        "$path": "src/Shared"
      },
      "$path": "build/ReplicatedStorage"
    },
    "ServerScriptService": {
      "Server": {
        "$path": "src/Server"
      },
      "$path": "build/ServerScriptService"
    },
    "ServerStorage": {
      "$path": "build/ServerStorage"
    },
    "SoundService": {
      "$path": "build/SoundService"
    },
    "StarterGui": {
      "$path": "build/StarterGui"
    },
    "StarterPack": {
      "$path": "build/StarterPack"
    },
    "StarterPlayer": {
      "$path": "build/StarterPlayer"
    },
    "Teams": {
      "$path": "build/Teams"
    },
    "TextChatService": {
      "$path": "build/TextChatService"
    },
    "Workspace": {
      "$path": "build/Workspace"
    }
  },
  "syncbackRules": {
    "ignoreTrees": [
      "ReplicatedFirst/Client",
      "ReplicatedStorage/Packages",
      "ReplicatedStorage/Shared",
      "ServerScriptService/Server"
    ],
    "syncCurrentCamera": false,
    "syncUnscriptable": true,
    "ignoreReferents": false
  }
}
```

The `syncbackRules.ignoreTrees` *must* list any paths managed by your source code (e.g. `Source/Client`, `Source/Shared`, `Source/Server`) and `Packages`, so that`syncback doesn't overwrite them or duplicate them in your build file.
