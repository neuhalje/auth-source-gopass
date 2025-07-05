# CHANGELOG for auth-source-gopass

_newest tag first, each tag sorted in chronological order (oldest first)_

## v0.0.4 (2025-07-05)
Switch from path based key lookup where the caller needs to know the whole path to a search based workflow. 

### Breaking Changes
- `auth-source-gopass-construct-query-path` removed: this is now done by searching
- The `user` is taken from the gopass secret, the secret's path, or the passed parameter of the user (in this order). Before it always was the passed in parameter.
- Switching to use `gopass find` may find more secrets. E.g. The query for the user `name` will now also find the users `myname` and `misnamer`

### Changes

*  Add Melpa Badge (/Markus M. May <160079+triplem@users.noreply.github.com>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/c9f7dc4da6178ca122e488e9ea07f20ccd29d87e)
*  fix: correctly handle not found secrets (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/9cd22a0dc183226d57677358c6782a4c769111c6)
*  feat: use dedicated *gopass* buffer for debugging (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/b5503f95235ff22b9858211b1605eda58011e12a)
*  fix: actually return nil when gopass is not found (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/065dea9153a559729ac82eded30d97cfe7510901)
*  fix: actually return the password.. (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/52440313e7fbc7baa7efb0dc6d2d0a85efc29c7f)
*  feat: add fn to find all candidates for the query (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/40397df97b47968b2822daaa1b15ecdf866ecf93)
*  feat: add parser for secrets to extract username (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/e4fe58d1267635555e694854dfd748f86911a164)
*  feat(get-secret): extract fallback user from path (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/1a164ae0c8d908330a45fa548d02b1173e2d3786)
*  feat: switch to a search based approach (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/13ffb7b26617799e82a826c01933484455851b04)
*  feat: add changelog builder (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/565d4d40c29b0e803284c3f2e81bab4a49635237)
*  feat: remove now unused `...-construct-query-path` (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/cab5207a188e5224c6131ba3ffbca6064cc0a53d)
*  fix: respect auth-source-gopass-path-separator (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/29c285b37828c76b2861b01cb9935d988a34b1da)
*  docs: bump to 0.0.4; add Jens as author & (C) (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/6e4d77211926e47047f7cd016bad934218b5d96e)
*  build: .gitignore scratch notes file (/Jens Neuhalfen <jens@neuhalfen.name>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/5004496c063ec48083ee48689ed4a2dd361c69ef)


## v0.0.3 (2023-01-09)

*  ignore .elc files for git (/triplem <160079+triplem@users.noreply.github.com>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/d374f1818d26b0f6cfe2541100ca098f2ccabf97)
*  chore: resolve comments in melpa PR (/May, Markus <mmay@conet.de>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/6f7f0cc0d682f66d11f7fac4fa5c1e79904232da)


## v0.0.2 (2023-01-02)

*  minor fixes for melpa preparation (/triplem <160079+triplem@users.noreply.github.com>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/7df0cad9b998f9bb4fb9a82fd4a97a1acb1889aa)


