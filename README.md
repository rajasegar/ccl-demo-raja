# Heroku App for Common Lisp

[![pipeline status](https://gitlab.com/duncan-bayne/heroku-app-clozure-common-lisp/badges/master/pipeline.svg)](https://gitlab.com/duncan-bayne/heroku-app-clozure-common-lisp/commits/master) [![lisp logo](./static/lisp-logo120x80.png)](http://lisp-lang.org/)

This is a template Clozure Common Lisp application for deployment with the [heroku-buildpack-common-lisp](https://gitlab.com/duncan-bayne/heroku-buildpack-common-lisp) buildpack.

<!-- TODO: duncan@bayne.id.au: Fix use of postimg once https://gitlab.com/gitlab-org/gitlab-ce/issues/17987 is resolved. -->
![webapp screenshot](https://s33.postimg.cc/nqliwvlnz/Screen_Shot_2018-06-08_at_12.18.28.png)

## development

### history

This application is a forked and highly modified version of [bhyde](https://github.com/bhyde)'s [heroku-buildpack-ccl64-example](https://github.com/bhyde/heroku-buildpack-ccl64-example).

### principles

1. Use modern Common Lisp tooling (in particular, [Roswell](https://github.com/roswell/roswell) and [QuickLisp](http://www.quicklisp.org/)).
2. Use CI and linting to prevent bit-rot and avoidable bugs.
3. Support the latest Heroku stack (currently [heroku-18](https://devcenter.heroku.com/articles/heroku-18-stack)).

## licence
heroku-app-clozure-common-lisp is licensed under the GNU Lesser General Public License.

### why the LGPL?
The GPL is specifically designed to reduce the usefulness of GPL-licensed code to closed-source, proprietary software. The BSD license (and similar) do not mandate code-sharing if the BSD-licensed code is modified by licensees. The LGPL achieves the best of both worlds: an LGPL-licensed library can be incorporated within closed-source proprietary code, and yet those using an LGPL-licensed library are required to release source code to that library if they change it.

## credits
* [bhyde](https://github.com/bhyde) for [heroku-buildpack-ccl64](https://github.com/bhyde/heroku-buildpack-ccl64).
* The [author](https://github.com/roswell/roswell#author) and [contributors](https://github.com/roswell/roswell#contributors) of [Roswell](https://github.com/roswell/roswell).
* [Mike Travers](hyperphor.com) for heroku-buildpack-cl2.
* [Anton Vodonosov](https://github.com/avodonosov) for his fork of heroku-buildpack-cl.
* [Mike Travers](hyperphor.com) for heroku-buildpack-cl.
* Heroku and their new [Buildpack-capable stack](http://devcenter.heroku.com/articles/buildpacks).
* [Zach Beane](https://github.com/xach) for [QuickLisp](http://www.quicklisp.org/) library manager and the [Quickproject](https://www.xach.com/lisp/quickproject/) tool.
* [Clozure Common Lisp](http://ccl.clozure.com/).
* [azzamsa](https://github.com/azzamsa) for the [SVG Lisp Logo](https://github.com/azzamsa/lisp-logo), Manfred Spiller for the original design, and [Xah Lee](http://xahlee.info/) for the background.
* All other countless lispers and developers of all generations who made this possible.
