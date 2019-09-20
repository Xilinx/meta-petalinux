###############################################################################
#
# Copyright (c) 2019, Xilinx
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Author: Izhar Shaikh <izhar.ameer.shaikh@xilinx.com>
#
###############################################################################

from collections import OrderedDict
from IPython.display import Image, display
from pydot import Dot, Edge, Node


class clk_node():
    def __init__(self, line):
        self.line = line
        self.attr_v = {}
        self.attr_i = [
            'name',
            'enable_count',
            'prepare_count',
            'protect_count',
            'rate',
            'accuracy',
            'phase',
            'duty_cycle',
        ]
        self._depth = 0
        self._depth_idx = 0

    def _set_depth(self):
        for c in self.line:
            if c.isspace():
                self._depth += 1
                continue
            else:
                break
        if (self._depth - 1) % 3 != 0:
            raise Exception('ERROR: clock depth is not multiple of 3')
        self._depth_idx = int((self._depth - 1) / 3)

    def parse(self):
        self._set_depth()
        ln_attr = self.line.strip().split()
        self.attr_v = {attr: ln_attr[i]
                       for i, attr in enumerate(self.attr_i)}

    def __repr__(self):
        ln = "-- {0:<3}: {1}".format(self._depth, self.line.strip().split())
        return ln

    def get_attr(self, attr):
        if attr in self.attr_i:
            return self.attr_v[attr]

    def get_depth_idx(self):
        return self._depth_idx


def _get_clk_dict(filep):
    '''
        Returns an OrderedDict() object with:
            - clock names as keys
            - clk_node object as values
    '''
    clk_dict = OrderedDict()
    clk = None
    with open(filep, 'r') as fp:
        skip = 3
        for line in fp:
            if skip:
                skip -= 1
            else:
                ls = line.rstrip()
                clk = clk_node(ls)
                clk.parse()
                clk_dict[clk.get_attr('name')] = clk
    return clk_dict


clk_dict = _get_clk_dict('/sys/kernel/debug/clk/clk_summary')
clk_keys = [clk_name for clk_name in clk_dict.keys()]
graph = Dot(graph_type='digraph')


def _if_subtree_exists(start):
    '''
        Returns true if given node has at least one child node
    '''
    start_idx = clk_keys.index(start)
    root_depth = clk_dict[start].get_depth_idx()
    if start_idx < len(clk_keys)-1:
        next_depth = clk_dict[clk_keys[start_idx+1]].get_depth_idx()
        if next_depth > root_depth:
            return True
    return False


def _get_immediate_children_nodes(start):
    '''
        Returns an immediate children node list of given node
    '''
    start_idx = clk_keys.index(start)
    root_depth = clk_dict[start].get_depth_idx()    # current depth
    out = []
    if start_idx < len(clk_keys)-1:
        for clk_node in clk_keys[start_idx+1:]:     # from next entry
            next_depth = clk_dict[clk_node].get_depth_idx()
            if next_depth > root_depth:             # loop over all children
                if next_depth == root_depth+1:      # immediate children
                    out.append(clk_node)
            else:
                break   # break at first node from the same level
    return out


def _mk_graph_node(clk):
    '''
        Returns a graph node with custom label
    '''
    clk_rate = int(clk_dict[clk].get_attr('rate'))/(10**6)
    labelstr = '{0} MHz'.format(clk_rate)
    labelstr = "<{0}<BR /><FONT POINT-SIZE=\"10\">{1}</FONT>>".format(
        clk, labelstr)
    node = Node(clk, label=labelstr)
    return node


def traverse_tree(start):
    '''
        Recursively traverse the parsed clk_dict object
        and create a n-ary tree and setup a directed dot graph
    '''
    if not _if_subtree_exists(start):
        return
    p_node = _mk_graph_node(start)
    graph.add_node(p_node)
    children = _get_immediate_children_nodes(start)
    # subtree exists, recurse for children
    for child in children:
        c_node = _mk_graph_node(child)
        graph.add_node(c_node)
        graph.add_edge(Edge(p_node, c_node))
        traverse_tree(child)
    return


def run_demo():
    print("Traversing system clock tree..", end='')
    traverse_tree('ref_clk')
    print("Done.")
    print("Generating clock tree for \"ref_clk\"..", end='')
    graph.write_png('clktree.png')
    print("Done.")
    display(Image('clktree.png'))
