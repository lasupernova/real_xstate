from unittest import TestCase
from cashflow_calc import *


class CalcTest(TestCase):
    def test_rental_assoc_expenses_m(self):
        expected = (211.5, 117.5, 117.5)
        self.assertEqual(expected, rental_assoc_expenses([700, 800, 850]))

    def test_rental_assoc_expenses_y(self):
        expected = (211.5, 117.5, 117.5)
        self.assertEqual(expected, rental_assoc_expenses([700*12, 800*12, 850*12], "year"))
