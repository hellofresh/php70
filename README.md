# Base php 7.0 docker image

[![Docker Repository on Quay](https://quay.io/repository/hellofresh/php70/status?token=4f1106f0-07a4-457d-95a2-b143611fe98c "Docker Repository on Quay")](https://quay.io/repository/hellofresh/php70)

This should be used only as a based image for application specific images which want to use php 7.0.

A domain-less vhost is configured by default to serve an `index.php` front controller from `/server/http/public`. This works out of the box with laravel web apps; tweaks might be necessary for other frameworks.

Running a container off this image and accessing it on the browser runs `./files/public/index.php`, which yields the output of `phpinfo()`.

### Building an app on top of this image

+ Create a new image for the app, based on this one.
+ Make sure to override any necessary settings, both on nginx and on php.
+ If possible, keep serving it from `/server/http/public` for consistency across apps.

### To do:

+ Include php.ini in the image, so as to more easily tweak defaults.
