#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  6 08:30:29 2022

@author: lauri
"""

import pandas
import typing 
import json

units_table = '/home/lauri/Desktop/Twist_Solid/units.tsv'
samples_table = '/home/lauri/Desktop/Twist_Solid/samples.tsv'

with open('/home/lauri/Desktop/Twist_Solid/config/output_list.json') as output:
    output_json = json.load(output)

units = (
    pandas.read_table(units_table, dtype=str)
    .set_index(["sample", "type", "flowcell", "lane", "barcode"], drop=False)
    .sort_index()
)

samples = pandas.read_table(samples_table, dtype=str).set_index("sample", drop=False)

def get_samples(samples: pandas.DataFrame) -> typing.List[str]:
    """
    function used to extract all sample found in samples.tsv
    Args:
        units: DataFrame generate by importing a file following schema defintion
               found in pre-alignment/workflow/schemas/units.schema.tsv
    Returns:
        List of strings with all sample names
    """
    return [sample.Index for sample in samples.itertuples()]


def get_unit_types(units: pandas.DataFrame, sample: str) -> set:
    """
    function used to extract all types of units found for a sample in units.tsv (N,T,R)
    Args:
        units: DataFrame generate by importing a file following schema defintion
               found in pre-alignment/workflow/schemas/units.schema.tsv
        wildcards: wildcards object with at least the following wildcard names
               sample.
    Returns:
        set of type types ex set("N","T")
    Raises:
        raises an exception (KeyError) if no unit(s) can be extracted from the Dataframe
    """
    return set([u.type for u in units.loc[(sample,)].dropna().itertuples()])

callers = ['vardict', 'gatk_mutect_2']
#def compile_output_list(wildcards):
output_files = []
types = set([unit.type for unit in units.itertuples()])
for output in output_json:
    output_files += set(
        [
            output.format(sample=sample, type=unit_type, caller=caller)
            for sample in get_samples(samples)
            for unit_type in get_unit_types(units, sample)
            if unit_type in set(output_json[output]["types"]).intersection(types)
            for caller in callers
        ]
    )
print(output)
#    return list(set(output_files))
