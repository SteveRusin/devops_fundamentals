#! /usr/bin/env bash -xe 

declare creation_date=$(date +'%Y_%m_%d_%H_%M')
declare branch=""
declare owner=""
declare poll_for_source_changes=""
declare build_configuration=""
declare path_to_file=$1


if ! command -v jq &> /dev/null
then
    echo "jq command not found. Install it using system package manager"
    echo "e.g 'brew install jq'"
    exit 1;
fi

if [[ ! -f $path_to_file ]] then
    echo "target file not found"
    exit 1;
fi

hasAllProperties=$(jq \
    '
    [
    .pipeline.version,
    .pipeline.stages[0].actions[0].configuration.Branch,
    .pipeline.stages[0].actions[0].configuration.Owner,
    .pipeline.stages[0].actions[0].configuration.PollForSourceChanges
    ] | all
    ' < $path_to_file)

    if [[ ! $hasAllProperties == "true" ]] then
        echo "not all props exist"
        exit 1
    fi

 jq --arg branch "$branch" \
         --arg owner "$owner" \
         --arg poll_for_source_changes "$poll_for_source_changes" \
         --arg build_configuration "$build_configuration" \
         '
          del(.metadata) |
          .pipeline.version = (.pipeline.version + 1) |
          if ($branch != "") then .pipeline.stages[0].actions[0].configuration.Branch = $branch else . end |
          if ($owner != "") then .pipeline.stages[0].actions[0].configuration.Owner = $owner else . end |
          if ($poll_for_source_changes != "") then .pipeline.stages[0].actions[0].configuration.PollForSourceChanges = ($poll_for_source_changes | test("true")) else . end|
          if ($build_configuration != "") then .pipeline.stages 
                                 |= map (
                                 if (.actions[0].configuration.EnvironmentVariables | type) == "string"
                                 then .actions[0].configuration.EnvironmentVariables = (
                                     .actions[0].configuration.EnvironmentVariables | sub("{{BUILD_CONFIGURATION value}}"; $build_configuration)
                                     ) else . end)
          else . end
         ' < $path_to_file
