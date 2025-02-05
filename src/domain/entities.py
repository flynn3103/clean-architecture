# coding: utf-8

from dataclasses import dataclass
from datetime import date


@dataclass
class Currency:
    """
    Represents a currency with its code, name, and symbol.
    """
    code: str
    name: str
    symbol: str

    def __str__(self) -> str:
        """
        Return a human-readable representation of the currency.
        
        Examples:
            - "USD ($): United States Dollar"
            - "JPY: Japanese Yen" (if no symbol is provided)
        """
        symbol_formatted = f" ({self.symbol}):" if self.symbol else ":"
        return f"{self.code}{symbol_formatted} {self.name}"


@dataclass
class CurrencyExchangeRate:
    """
    Represents the exchange rate between two currencies on a specific valuation date.
    """
    source_currency: Currency
    exchanged_currency: Currency
    valuation_date: date
    rate_value: float

    def __str__(self) -> str:
        """
        Return a human-readable representation of the currency exchange rate.
        
        Example:
            "USD/EUR = 0.85 (2023-10-01)"
        """
        return (
            f"{self.source_currency.code}/{self.exchanged_currency.code} "
            f"= {self.rate_value} ({self.valuation_date})"
        )
