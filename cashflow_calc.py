def rental_assoc_expenses(rents:list):
    """
    Calculates rent associated expenses.

    Params:
        rents (list) - list of all rental incomes in property

    Returns
        x, y, z (tuple) - tuple containing x=property managment fees, y=vacancy and z=capital expenditures
    """
    total_rent = sum(rents)
    prop_mgmt = total_rent*0.09
    vacancy_loss = capital_exp = total_rent*0.05
    return prop_mgmt, vacancy_loss, capital_exp


def calculate_net_op_costs_MO(costs:list):
    """
    Returns monthly net operating costs
    """
    return sum(costs)/12


def calculate_net_op_income(rents:list, costs:float, period:str):
    """
    Returns monthly net operating income

    Params:
        rents (list)    - list of monthly rents in property
        costs (float)   - costs (as calculated by calculate_net_op_costs_MO())
        period (string) - indicates if monthly or yearly net op income should be calculated (options: "y" -yearly, "m" -monthly)

    Returns:
        net_op_income (float)
    """
    if period.lower() == "m":
        return sum(rents) - costs
    elif period.lower()=="y":
        return sum(rents)*12 - costs*12
    else:
        raise ValueError(f'Please pass "y" or "m" for "period"!\nCurrently passed: "{period}"')


def calculate_cashflow(rents:list, expenses:float, period:str="m"):
    """
    Returns monthly net operating income

    Params:
        rents (list)       - list of monthly rents in property
        expenses (float)   - expenses (as calculated by calculate_net_op_costs_MO())
        period (string)    - indicates if monthly or yearly net op income should be calculated (options: "y" -yearly, "m" -monthly)

    Returns:
        cashflow
    """
    if period.lower() == "m":
        return sum(rents)/12 - costs
    elif period.lower()=="y":
        return sum(rents) - costs*12
    else:
        raise ValueError(f'Please pass "y" or "m" for "period"!\nCurrently passed: "{period}"')


if __name__=="__main__":
    print(rental_assoc_expenses([750, 900]))

