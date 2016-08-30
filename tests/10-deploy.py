#!/usr/bin/python3

import amulet
import subprocess
import unittest


class TestCharm(unittest.TestCase):
    def setUp(self):
        self.d = amulet.Deployment(series='xenial')

        self.d.add('sshd')
        self.d.expose('sshd')

        self.d.setup(timeout=900)
        self.d.sentry.wait()

        self.unit = self.d.sentry['sshd'][0]

    def test_service(self):
        '''Test that you can ssh to the system.'''
        # ssh ubuntu@52.53.238.205 -p 3128 
        # Common ports used by some proxy servers are:
        # 8080, 80, 3128, 6588
