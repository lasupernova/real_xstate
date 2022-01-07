class MobileTxtTemplates():
    def __init__(self):
        self.cashflow_text = ""

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
                    [h1]Cashflow Information[/h1]
        
        [h2]General[/h2]
            Total Investment: {info_dict["general"]["total_investment"]}
            Rental Associated Expenses: {info_dict["general"]["rental_assoc_exp"]}
            Rent-to-Price Ratio: {info_dict["general"]["rent_to_price_ratio"]}

        [h2]Real[/h2]
            Net Operating Income: {info_dict["real"]["net_op_income_MO"]} (monthly) / {info_dict["real"]["net_op_income_YR"]} (yearly)
            Net Operating Cost: {info_dict["real"]["net_op_cost"]}
            Total Monthly Expenses: {info_dict["real"]["total_monthly_exp"]}
            Cashflow: {info_dict["real"]["cashflow_MO"]} (monthly) / {info_dict["real"]["cashflow_YR"]} (yearly)
            COC ROI: {info_dict["real"]["coc_ROI"]}
            CAP: {info_dict["real"]["CAP"]}
            ROI: {info_dict["real"]["ROI"]}
            ROI Date: {info_dict["real"]["ROI_date"]}

        [h2]Hypo[/h2]
            Net Operating Income: {info_dict["hypo"]["net_op_income_MO"]} (monthly) / {info_dict["real"]["net_op_income_YR"]} (yearly)
            Net Operating Cost: {info_dict["hypo"]["net_op_cost"]}
            Total Monthly Expenses: {info_dict["hypo"]["total_monthly_exp"]}
            Cashflow: {info_dict["hypo"]["cashflow_MO"]} (monthly) / {info_dict["real"]["cashflow_YR"]} (yearly)
            COC ROI: {info_dict["hypo"]["coc_ROI"]}
            CAP: {info_dict["hypo"]["CAP"]}
            ROI: {info_dict["hypo"]["ROI"]}
            ROI Date: {info_dict["hypo"]["ROI_date"]}
        """