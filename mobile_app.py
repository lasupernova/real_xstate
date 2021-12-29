from kivy.app import App 
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, Screen, FallOutTransition
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.textinput import TextInput
import json, glob
from datetime import datetime
from pathlib import Path
import random
# from hoverable import HoverBehavior
from kivy.uix.image import Image
from kivy.uix.label import Label
from kivy.uix.behaviors import ButtonBehavior
from kivy.uix.widget import Widget
from kivy.properties import NumericProperty, ReferenceListProperty
from kivy.vector import Vector
from kivy.core.window import Window
from kivy.config import Config
import mortgage_calc
import os


# Config.set('kivy','window_icon',f"static{os.sep}icon{os.sep}tkinter_icon.png")  TODO: custom icon

class RootWidget(ScreenManager):
    def __init__(self, **kwargs):
        super(RootWidget, self).__init__(**kwargs)
        # add screens to be managed -- NOTE: first screen added will be the starting screen
        self.add_widget(CalculateMortgage(name='mortgage'))
        self.add_widget(CashflowInfo(name='screen2'))
        


class CalculateMortgage(Screen):
    '''
        no need to do anything here as
        building things in .kv file
    '''
    def __init__(self, **kw):
        super(CalculateMortgage, self).__init__(**kw)

    def calculate_payment(self, mortgage_period, interest_rate, downpayment, offer):
        if "" in [mortgage_period, interest_rate, downpayment, offer]:
            self.ids.mortgage_payment.height = 0
            self.ids.total_cost.height = 0
            border_cols = ['r' if x=="" else None for x in [mortgage_period, interest_rate, downpayment, offer]]
            missing = [name for x, name in zip([mortgage_period, interest_rate, downpayment, offer], ['mortgage period', 'interest rate', 'downpayment', 'offer']) if x==""]
            self.ids.missing_entry.text = f"Fill in the missing values: {', '.join(missing)}"
            return 1
        loan = (1-float(downpayment)/100)*float(offer)
        interest_rate = float(interest_rate) / 100
        # monthly payment
        result = mortgage_calc.mortgage_calc(loan, float(interest_rate)/12,int(mortgage_period))
        #total cost 
        total_cost = mortgage_calc.total_cost(loan, float(interest_rate)/12, int(mortgage_period))
        # self.mortgage_payment = result
        self.ids.mortgage_payment.text = f"""
[b]Monthly Payment[/b]
[size=25]$ {result:.2f}[/size]
        """
        self.ids.total_cost.text = f"""
[b]Total Cost[/b]
[size=25]$ {total_cost:.2f}[/size]
        """


class CashflowInfo(Screen):
    def __init__(self, **kw):
        super(CashflowInfo, self).__init__(**kw)

    def on_enter(self, *args):
        print(self.manager.ids)
        self.mortgage = self.manager.get_screen('mortgage').ids.total_cost.text
        self.mortgage_payments = self.manager.get_screen('mortgage').ids.mortgage_payment.text
        print(f"TOTAL MORTGAGE: {self.mortgage}")
        print(f"Monthly Payments: {self.mortgage_payments}")
    
    def calculate_ROI(self, *args):
        """
        Iterated over widget tree (using walk() ) starting at 'ROI_input', 
        identifies all children widgets that are of type TextInput,
        and calculates sum of all inserted values.
        """
        def __get_ROI_input__(x):
            "Check if value was inputed and return inputted value or zero."
            cond2 = x.text
            if cond2:
                return float(x.text)
            else:
                return 0

        print(sum([__get_ROI_input__(wid) for wid in self.manager.get_screen('screen2').ids.ROI_input.walk() if type(wid)== TextInput]))
        # print([type(wid) for wid in self.manager.get_screen('screen2').ids.ROI_input.walk()])
  
    def switch_timeframe(self, current_button, current_input):
        """
        Changes current timeframe button text and current TextInput text based between monthly and yearly expense 
        based on current value (text) of current timeframe button.

        Params:
            current_button: timeframe  button that was clicked (default text: '$/Year')
            current_input: TextInput field associated with clicked tiemframe button

        Returns:
            0 if successfully exited
        """
        if current_input.text != "":  #TextInput default text is an empty string of length 0
            curr_val = float(current_input.text)
            current_input.text = f"{curr_val/12 if current_button.text=='$/Year' else curr_val*12}"
        current_button.text = "$/Month" if current_button.text=="$/Year" else "$/Year"
        print("New TimeFrame: ",current_button.text)
        return 0 
        
#################################################  
# class in which name .kv file must be named KVBoxLayout.kv. 
class MainApp(App):
    txt_input_size = 30
    def build(self):
        # Create the screen manager
        # return ScreenManager()
        self.icon = f"static{os.sep}icons{os.sep}tkinter_icon.png"
        self.title = "realXstate"
        return RootWidget()
 
  
##################################################

if __name__ == "__main__":
    # creating the object root for BoxLayoutApp() class  
    MainApp().run()