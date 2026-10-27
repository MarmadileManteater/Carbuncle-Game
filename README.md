# Godot Game Repository Template

In order to reduce headache when scaffolding projects, this is all of the housekeeping files that we need when making games. 

Stuff like:

- a solid .gitignore
- the godot license file
- a github workflow for building godot games and pushing them to itch

> [!NOTE]  
> In order for the workflow to work, you need to set the `ITCH_API_KEY` ([https://itch.io/docs/butler/login.html](https://itch.io/docs/butler/login.html#running-butler-from-ci-builds-github-actions-gitlab-ci-etc)) AND you need to fill out your `project.json` with the relevant info such as the itch user and project stub. 
