# Starwars Demo for Common Lisp and HTMX

[![lisp logo](./static/lisp-logo120x80.png)](http://lisp-lang.org/)


This is a demo app built with [Common Lisp](https://lisp-lang.org), [htmx](https://htmx.org) and [hyperscript](https://hyperscript.org).

## Demo

[Starwars](https://ccl-demo-raja.herokuapp.com)

## Local development

### Pre-requisites
- [sbcl](http://www.sbcl.org/)
- [quicklisp](https://www.quicklisp.org/beta/)

Clone the repo and load it in sbcl with quicklisp.

```
cd ~/quicklisp/local-projects
git clone https://github.com/rajasegar/ccl-demo-raja
```

```lisp
(ql:quickload :ccl-demo-raja)
```

Start the server with the function `initiliaze-application`
```lisp
(initiliaze-application :port 3000)
```

Visit the url `http:///localhost:3000` in the browser.
