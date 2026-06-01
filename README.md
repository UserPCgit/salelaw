# law_onboarding

Standalone cinematic onboarding resource for FiveM.

This first version does **not** integrate with FivePD or your future website yet. It only handles:

- first-time faction / department / division selection;
- saving the player's selected assignment;
- skipping onboarding for returning players;
- showing a welcome-back screen after long inactivity;
- department services marker for changing assignment;
- basic locker / armory / garage markers;
- patrol setup checklist;
- basic vehicle spawn and loadout issue.

## Install on Nitrado

1. Upload the whole `law_onboarding` folder to:

```text
resources/law_onboarding
```

2. Add to `server.cfg`:

```cfg
ensure law_onboarding
```

Recommended order:

```cfg
ensure law_onboarding
ensure fivepd
```

3. Restart the server.

## Commands

```text
/tutorial          Show patrol checklist or open selection if no profile exists.
/department        Open assignment selection for testing/change.
/resetonboarding   Reset your saved onboarding profile.
```

## Important

Profiles are saved in:

```text
data/profiles.json
```

This is fine for MVP/testing. Later, replace it with your website/API or database.

## Current structure

```text
Faction
→ Category
→ Department
→ Division
→ Specialization
```
