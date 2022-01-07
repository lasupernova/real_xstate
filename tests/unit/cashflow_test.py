from unittest import TestCase
from cashflow_calc import *


class CalcTest(TestCase):
    def test_rental_assoc_expenses_m(self):
        expected = (211.5, 117.5, 117.5)
        self.assertEqual(expected, rental_assoc_expenses([700, 800, 850]))

    def test_rental_assoc_expenses_y(self):
        expected = (211.5, 117.5, 117.5)
        self.assertEqual(expected, rental_assoc_expenses([700*12, 800*12, 850*12], "year"))

    def test_total_expenses_actual(self):
        actual = total_expenses_MO(rents=[700, 800, 850], costs=[100, 200, 150], monthly_payment=400.0, hypo=False, rent_period="m", cost_period="y")
        expected = sum([211.5, 117.5, 117.5]) + sum([100/12, 200/12, 150/12]) + 400
        self.assertEqual(actual, expected)

    def test_total_expenses_hypo(self):
        actual = total_expenses_MO(rents=[700, 800, 850], costs=[100, 200, 150], monthly_payment=400.0, hypo=True, rent_period="m", cost_period="y")
        expected = 211.5 + sum([100/12, 200/12, 150/12]) + 400
        self.assertEqual(actual, expected)

    def test_calculate_net_op_income_month(self):
        net_costs = total_expenses_MO(rents=[700, 800, 850], costs=[100, 200, 150], monthly_payment=400.0, hypo=False, rent_period="m", cost_period="y")
        expected = sum([700, 800, 850]) - net_costs
        self.assertEqual(expected, calculate_net_op_income([700, 800, 850], net_costs, "m"))

    def test_calculate_net_op_income_year(self):
        net_costs = total_expenses_MO(rents=[700, 800, 850], costs=[100, 200, 150], monthly_payment=400.0, hypo=False, rent_period="m", cost_period="y")
        expected = (sum([700, 800, 850]) - net_costs) * 12
        self.assertEqual(expected, calculate_net_op_income([700, 800, 850], net_costs, "y"))

    def test_calculate_net_op_income_except(self):
        """ Test that exception is raised on un-allowed input """
        with self.assertRaises(ValueError):
            calculate_net_op_income([700, 800, 850], 0, "x")

    def test_calculate_cashflow_actual(self):
        expenses = total_expenses_MO(rents=[700, 800, 850], costs=[100, 200, 150], monthly_payment=400.0, hypo=False, rent_period="m", cost_period="y")
        expected = sum([700, 800, 850]) - expenses
        self.assertEqual(expected, calculate_cashflow([700, 800, 850], expenses, "m"))

    def test_calculate_cashflow_hypo(self):
        expenses = total_expenses_MO(rents=[700, 800, 850], costs=[100, 200, 150], monthly_payment=400.0, hypo=True, rent_period="m", cost_period="y")
        expected = sum([700, 800, 850]) - expenses
        self.assertEqual(expected, calculate_cashflow([700, 800, 850], expenses, "m"))

    def test_calculate_cashflow_except(self):
        with self.assertRaises(ValueError):
            calculate_cashflow([700, 800, 850], 0, "x")

    def test_total_investment(self):
        expected = 28000+1500+10000+300+2000
        self.assertEqual(expected, total_investment(28000, 1500, 10000, 300, 2000))
