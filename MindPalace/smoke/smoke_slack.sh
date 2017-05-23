#!/bin/bash

GIT_USER=$(git show -s | grep -hio "\b[a-z0-9.-]\+@[a-z0-9.-]\+\b")
BUILD_NUMBER=$1
JOB_URL=$2
BUILD_URL=$3
SLACK_MESSAGE=$4
SLACK_COLOR=$5
BRANCH_NAME=$6
SLACK_CHANNEL=@$(git show -s | grep -hio "\b[a-z0-9.-]\+@[a-z0-9.-]\+\b" | sed -E 's/(.*)@{1}(.*)/\1/')

case "${SLACK_CHANNEL,,}" in
    @gverma)
        SLACK_CHANNEL="@gopinder"
        ;;

    @admin)
        SLACK_CHANNEL="@mjanda"
        ;;

    @jzwerling)
        SLACK_CHANNEL="@jesse_z"
        ;;

    @bmerrell)
        SLACK_CHANNEL="@brianm"
        ;;
esac

curl -s -X POST -d "{\"icon_emoji\": \":ghost:\", \"username\": \"$GIT_USER\", \"channel\": \"$SLACK_CHANNEL\", \"attachments\": [{ \"author_name\": \"Mind Palace\", \"title\": \"Build $BUILD_NUMBER\", \"title_link\": \"$JOB_URL\", \"fallback\": \"Build $BUILD_NUMBER notification\", \"text\": \"$SLACK_MESSAGE\n<$BUILD_URL|status> | <$BUILD_URL/console|console>\", \"color\": \"$SLACK_COLOR\"}]}" https://hooks.slack.com/services/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

if [ "$SLACK_COLOR" == "danger" ] && [ "$BRANCH_NAME" == "master" ] ; then
    SLACK_CHANNEL="#mind-palace"

    curl -s -X POST -d "{\"icon_emoji\": \":ghost:\", \"username\": \"$GIT_USER\", \"channel\": \"$SLACK_CHANNEL\", \"attachments\": [{ \"author_name\": \"Mind Palace\", \"title\": \"Build $BUILD_NUMBER\", \"title_link\": \"$JOB_URL\", \"fallback\": \"Build $BUILD_NUMBER notification\", \"text\": \"$SLACK_MESSAGE\n<$BUILD_URL|status> | <$BUILD_URL/console|console>\", \"color\": \"$SLACK_COLOR\"}]}" https://hooks.slack.com/services/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
    #echo "Slack notification of git commit by $GIT_USER was sent to $SLACK_CHANNEL"
fi
