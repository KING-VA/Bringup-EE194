#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#  intech22 Calibre DRC hooks.
#
import textwrap

from hammer.vlsi import HammerDRCTool, MentorCalibreTool, HammerTool

from typing import List, Dict, Tuple, Any, Iterable, Callable, Optional

def intech22_drc_run_file(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerDRCTool), "Calibre settings only for DRC"
    assert isinstance(ht, MentorCalibreTool), "Calibre is a Mentor tool"
    """ Generate the DRC run file self.drc_run_file and fill its contents """
    with open(ht.drc_run_file, "w") as f:
        f.write(textwrap.dedent("""
        // Generated by HAMMER

        LAYOUT PATH "{gds}"
        """).format(
            gds=ht.layout_file
        )
        )
        # Include paths to all supplied decks
        for rule in ht.get_drc_decks():
            f.write("INCLUDE \"{}\"\n".format(rule.path))
        # Note that an empty list means run all, and Calibre conveniently will do just that
        # if we don't specify any individual checks to run.
        if len(ht.drc_rules_to_run()) > 0:
            f.write("\nDRC SELECT CHECK\n")
        for check in ht.drc_rules_to_run():
            f.write("\t\"{}\"\n".format(check))
        f.write("\nDRC ICSTATION YES\n")
        f.write(ht.get_additional_drc_text())
    return True
