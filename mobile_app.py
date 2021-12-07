from kivy.app import App 
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, Screen 
from kivy.uix.boxlayout import BoxLayout
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

Builder.load_file('main.kv')
# Config.set('kivy','window_icon',f"static{os.sep}icon{os.sep}tkinter_icon.png")  TODO: custom icon

class RootWidget(ScreenManager):
    pass

class EvaluateInvestment(Screen):
    '''
        no need to do anything here as
        we are building things in .kv file
    '''
    def calculate_payment(self, mortgage_period, interest_rate, downpayment, offer):
        loan = (1-downpayment/100)*offer
        interest_rate /= 100
        # monthly payment
        result = mortgage_calc.mortgage_calc(loan, interest_rate/12, mortgage_period)
        #total cost 
        total_cost = mortgage_calc.total_cost(loan, interest_rate/12, mortgage_period)
        self.ids.mortgage_payment.text =f"""
monthly payment
$ {result:.2f}
        """
        self.ids.total_cost.text = f"""
total cost
$ {total_cost:.2f}
        """
  

#################################################  
# class in which name .kv file must be named KVBoxLayout.kv. 
class MainApp(App):
    def build(self):
        return RootWidget() #the instance (NOT the class) --> brackets
  
##################################################

if __name__ == "__main__":
    # creating the object root for BoxLayoutApp() class  
    MainApp().run()