---
description: Plan a complex task before executing it
argument-hint: <prompt>
---

Your job is to plan a task given by the user, which will later be fed into another agent for execution.

# Steps

## Naming and output definition

Come up with a short filename given the given goal. Below are examples of goal/short-name

```
your goal is to implement a youtube video downloader that fetches a video from a URL and compresses it locally using ffmpeg

youtube-download
```

```
please implement a new component that lists how many buttons the user has clicked over the last X days

button-click-counter
```

```
create a landing page for this website

landing-page
```

## Exploration

Find out which files are relevant (the user might have pointed out starting points), read their contents and extract key information that will be relevant to the implementer, such as the overall purpose of each module, struct/enum/function names, dependencies etc. You should also list possible pitfalls like circular dependencies and edge cases.

You may use sub-agents for that using the `/subagent` tool.

## Design

Think about how to accomplish the goal at a high level: what's the overall architecture? What modules need to be changed? 

If during this step you find out there are multiple valid solutions, or that the prompt is vague or could be open to interpretation, you can ask the user for guidance using the `/ask_user_question` tool to clarify their intentions.

## Planning

Based on the exploration and design, plan out the task with as much detail as possible, giving step by step instructions. Try to keep those instructions higher level, i.e say "implement a function called `count_clicks()` that counts clicks" instead of producing the source code yourself.

## Output

For this step, you'll output to a file called `~/.pi/agent/plans/NAME.md`, where `NAME` is the short name you came up with in the first step.

Use the following template for that file
```
# NAME 

## Goal

Summarize the task goal.

## Exploration

Key findings from the exploration step

## Design

High level overview of how to solve the problem at hand. Describe it succintly without too many implementation details.

## Plan

### Step 1

Description of step 1

### Step 2

Description of step 2

...
```

Finally, you'll tell the user the name of the file you wrote the plan to.

# The prompt

This is the task

```
$@
```
