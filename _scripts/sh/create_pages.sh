#!/usr/bin/env bash
#
# Create HTML pages for Categories and Events in posts.
#
# Usage:
#     Call from the '_posts' sibling directory.
#
# v2.2
# https://github.com/cotes2020/jekyll-theme-chirpy
# © 2020 Cotes Chung
# Published under MIT License

set -eu

TYPE_CATEGORY=0
TYPE_EVENT=1

category_count=0
event_count=0

_read_yaml() {
  local _endline="$(grep -n "\-\-\-" "$1" | cut -d: -f 1 | sed -n '2p')"
  head -"$_endline" "$1"
}

read_categories() {
  local _yaml="$(_read_yaml "$1")"
  local _categories="$(echo "$_yaml" | yq r - "categories.*")"
  local _category="$(echo "$_yaml" | yq r - "category")"

  if [[ -n $_categories ]]; then
    echo "$_categories"
  elif [[ -n $_category ]]; then
    echo "$_category"
  fi
}

read_events() {
  local _yaml="$(_read_yaml "$1")"
  local _events="$(echo "$_yaml" | yq r - "events.*")"
  local _event="$(echo "$_yaml" | yq r - "event")"

  if [[ -n $_events ]]; then
    echo "$_events"
  elif [[ -n $_event ]]; then
    echo "$_event"
  fi
}

init() {

  if [[ -d categories ]]; then
    rm -rf categories
  fi

  if [[ -d events ]]; then
    rm -rf events
  fi

  if [[ ! -d _posts ]]; then
    exit 0
  fi

  mkdir categories events
}

create_category() {
  if [[ -n $1 ]]; then
    local _name=$1
    local _filepath="categories/$(echo "$_name" | sed 's/ /-/g' | awk '{print tolower($0)}').html"

    if [[ ! -f $_filepath ]]; then
      echo "---" > "$_filepath"
      echo "layout: category" >> "$_filepath"
      echo "title: $_name" >> "$_filepath"
      echo "category: $_name" >> "$_filepath"
      echo "---" >> "$_filepath"

      ((category_count = category_count + 1))
    fi
  fi
}

create_event() {
  if [[ -n $1 ]]; then
    local _name=$1
    local _filepath="events/$(echo "$_name" | sed "s/ /-/g;s/'//g" | awk '{print tolower($0)}').html"

    if [[ ! -f $_filepath ]]; then

      echo "---" > "$_filepath"
      echo "layout: event" >> "$_filepath"
      echo "title: $_name" >> "$_filepath"
      echo "event: $_name" >> "$_filepath"
      echo "---" >> "$_filepath"

      ((event_count = event_count + 1))
    fi
  fi
}

#########################################
# Create HTML pages for Categories/Events.
# Arguments:
#   $1 - an array string
#   $2 - type specified option
#########################################
create_pages() {
  if [[ -n $1 ]]; then
    # split string to array
    IFS_BAK=$IFS
    IFS=$'\n'
    local _string=$1

    case $2 in

      $TYPE_CATEGORY)
        for i in $_string; do
          create_category "$i"
        done
        ;;

      $TYPE_EVENT)
        for i in $_string; do
          create_event "$i"
        done
        ;;

      *) ;;

    esac

    IFS=$IFS_BAK
  fi

}

main() {

  init

  for _file in $(find "_posts" -type f \( -iname \*.md -o -iname \*.markdown \)); do
    local _categories=$(read_categories "$_file")
    local _events=$(read_events "$_file")

    create_pages "$_categories" $TYPE_CATEGORY
    create_pages "$_events" $TYPE_EVENT
  done

  if [[ $category_count -gt 0 ]]; then
    echo "[INFO] Succeed! $category_count category-pages created."
  fi

  if [[ $event_count -gt 0 ]]; then
    echo "[INFO] Succeed! $event_count event-pages created."
  fi
}

main
