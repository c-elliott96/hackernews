<!-- disabled to abide by TODO.md spec -->
<!-- markdownlint-disable-file single-h1 -->
# TODO

Here I store the current TODO items for this project. Inspired by
[TODO.md][todo-md].

## Use `hn.algolia.com` API instead of HackerNews

- [ ] Update `app/services/hacker_news.rb` for requests
  
- [ ] Create controller, model, and tests for the appropriately named resource

## Figure out styling issues when rendering comment HTML

Tailwindcss's preflight base styling is interfering with the rendering of the
HTML we get from HackerNews comments. For example, the `<p>` tags are not
creating spaces between paragraphs. We render this markup directly, which means
we'll have to somehow dynamically add classes to this markup, or determine some
other solution.

- [ ] Add class that resets preflights, which can be applied to raw HTML

- [ ] If necessary, create wrapper elemenent (div) to style the background and
      spacing that we lose with focibly overriding preflights

# BACKLOG

In no particular order.

- [ ] Add some kind of CVE/deprecation scanner to keep dependencies up to date

- [ ] Figure out how to cleanly "rebase" from `docker-rails-example`

- [ ] Address/remove sporadic in-source TODOs not specified here

- [ ] Add markdownlint to GitHub actions CI pipeline

- [ ] Make `./run lint` execute all linter tasks and display useful output

- [ ] Move or delete the `## Development Changes` section in the README doesn't
      clutter it so much
      
- [ ] Make all links reference and not inline

# DONE

- [X] Bootstrap project

- [x] Add `./run ruby-lint -A` task

- [x] Add `./run markdownlint` task

<!-- Links -->
[todo-md]: https://github.com/todo-md/todo-md
