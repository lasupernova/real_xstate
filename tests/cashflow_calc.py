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
    vacancy_loss = total_rent*0.05
    capital_exp = total_rent*0.05
    return prop_mgmt, vacancy_loss, capital_exp
