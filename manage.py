# -*- coding:utf-8 -*-

from application import create_app
from application.settings.dev import DevelopmentConfig

app = create_app(DevelopmentConfig)


# @app.route('/test/user/<username>')
# def show_user_profile(username):
#     # show the user profile for that user
#     return 'User %s' % username
#
#
# @app.route('/test/post/<int:post_id>')
# def show_post(post_id):
#     # show the post with the given id, the id is an integer
#     return 'Post %d' % post_id
#
#
# @app.route('/test/path/<path:subpath>')
# def show_subpath(subpath):
#     # show the subpath after /path/
#     return 'Subpath %s' % subpath

