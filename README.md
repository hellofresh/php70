# Base php 7.0 docker image

[![Docker Repository on Quay](https://quay.io/repository/hellofresh/php70/status?token=1f9cb0ee-31ab-4601-b4f3-f61c710c0e0e "Docker Repository on Quay")](https://quay.io/repository/hellofresh/php70)

This should be used only as a based image for application specific images which want to use php 7.0.

A domain-less vhost is configured by default to serve an `index.php` front controller from `/server/http/public`. This works out of the box with laravel web apps; tweaks might be necessary for other frameworks.

Running a container off this image and accessing it on the browser runs `./files/public/index.php`, which yields the output of `phpinfo()`.

### Building an app on top of this image

+ Create a new image for the app, based on this one.
+ Make sure to override any necessary settings, both on nginx and on php.
+ If possible, keep serving it from `/server/http/public` for consistency across apps.

### To do:

+ Include php.ini in the image, so as to more easily tweak defaults.


License
-------

    Copyright (C) 2016 HelloFresh SE

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
