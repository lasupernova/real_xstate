import datetime
class MobileTxtTemplates():
    def __init__(self):
        self.cashflow_text = ""
        self.now = datetime.datetime.now()

    def fill_cashflow_text(self, info_dict):
        """
        Creates output text for cashflow results as calculated by mobile_app.CashFlowInfo.calculate_ROI(),
        based on input dictionary with information.
        Class property 'cashflow_text' be used by mobile_app to populate app with required information in 
        format defined below.

        PARAMS:
            info_dict (dict) - dict containing cashflow info ( return value of cashflow_calc.cashflow_overview() )

        RETURNS:
            Void function
        """
        self.cashflow_text = f"""
               [size=25][b][u]Cashflow Information[/b][/u][/size]
        
        [size=20][b]General Info[/b][/size]
            Total Investment: $ {info_dict["general"]["total_investment"]:.2f}
            Rental Associated Expenses: {", ".join([f'$ {cost} ({name})' for cost, name in zip({info_dict["general"]["rental_assoc_exp"]}, ['Property Mgmt', 'Vacancy (5%)', 'Capital Expenditures / Repairs (5%)'])])}
            Rent-to-Price Ratio: $ {info_dict["general"]["rent_to_price_ratio"]:.2f}

        [size=20][b]Real[/b][/size]
            Net Operating Income: $ {info_dict["real"]["net_op_income_MO"]:.2f} (monthly) / $ {info_dict["real"]["net_op_income_YR"]:.2f} (yearly)
            Net Operating Cost: $ {info_dict["real"]["net_op_cost"]:.2f}
            Total Monthly Expenses: $ {info_dict["real"]["total_monthly_exp"]:.2f}
            Cashflow: $ {info_dict["real"]["cashflow_MO"]:.2f} (monthly) / $ {info_dict["real"]["cashflow_YR"]:.2f} (yearly)
            COC ROI: $ {info_dict["real"]["coc_ROI"]:.2f}
            CAP: $ {info_dict["real"]["CAP"]:.2f}
            ROI: $ {info_dict["real"]["ROI"]:.2f}
            [b]ROI Date: {info_dict["real"]["ROI_date"].strftime('%Y-%b-%d')}[/b]

        [size=20][b]Hypo[/b][/size]
            Net Operating Income: $ {info_dict["hypo"]["net_op_income_MO"]:.2f} (monthly) / $ {info_dict["real"]["net_op_income_YR"]:.2f} (yearly)
            Net Operating Cost: $ {info_dict["hypo"]["net_op_cost"]:.2f}
            Total Monthly Expenses: $ {info_dict["hypo"]["total_monthly_exp"]:.2f}
            Cashflow: $ {info_dict["hypo"]["cashflow_MO"]:.2f} (monthly) / $ {info_dict["real"]["cashflow_YR"]:.2f} (yearly)
            COC ROI: $ {info_dict["hypo"]["coc_ROI"]:.2f}
            CAP: $ {info_dict["hypo"]["CAP"]:.2f}
            ROI: $ {info_dict["hypo"]["ROI"]:.2f}
            [b]ROI Date: {info_dict["hypo"]["ROI_date"].strftime('%Y-%b-%d')}[/b]
        """

        return self.cashflow_text