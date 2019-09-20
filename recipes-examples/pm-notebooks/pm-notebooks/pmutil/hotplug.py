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

from ipywidgets import widgets, Layout, Button, Box
from IPython.display import display
from subprocess import check_output
from pmutil import write_to_sysfs

buttons = []
output_widget = None
cpu_monitor = None

button_tags = [
    'CP0 [ON] + CPU1 [OFF]',    # Only CPU0 ON
    'CPU0 [OFF] + CPU1 [ON]',   # Only CPU1 ON
    'BOTH CPUs ON'              # Both CPUs ON
]

cpu0_on_img = open('pmutil/data/cpu-icon-0-on.png', 'rb').read()
cpu0_off_img = open('pmutil/data/cpu-icon-0-off.png', 'rb').read()
cpu1_on_img = open('pmutil/data/cpu-icon-1-on.png', 'rb').read()
cpu1_off_img = open('pmutil/data/cpu-icon-1-off.png', 'rb').read()

# handler args for each button
button_args = {
    button_tags[0]: [('1', '0'), (cpu0_on_img, cpu1_off_img)],
    button_tags[1]: [('0', '1'), (cpu0_off_img, cpu1_on_img)],
    button_tags[2]: [('1', '1'), (cpu0_on_img, cpu1_on_img)],
}


def _setup_output_widget():
    return widgets.Output()


def _setup_cpu_monitor_widgets():
    defimgs = [cpu0_on_img, cpu1_on_img]
    monitor = widgets.HBox(
        [widgets.Image(value=img, format='png', width='35%', height='35%')
         for img in defimgs])
    monitor.layout.justify_content = 'center'
    return monitor


def _setup_buttons_container(buttons_list):
    '''
        Returns an instance of "Box" which contains all "Button" widgets
    '''
    box_layout = Layout(display='flex',
                        flex_flow='column',
                        align_items='stretch',
                        border='solid',
                        width='100%')
    return Box(children=buttons_list,
               layout=box_layout)


def _mk_cpu_sysfs_path(cpu_id):
    return '/sys/devices/system/cpu/cpu{0}/online'.format(cpu_id)


def _write_to_sysfs(filepath, value):
    with output_widget:
        if write_to_sysfs(filepath, value) < 0:
            print("Error while writing to {0}".format(filepath))
        else:
            print('Written {0} -> {1}'.format(value, filepath))


def _handle_cpu_cntl(cpu_pair):
    '''
    Handles turning on/off for CPUs:
        `cpu_pair` is a tuple where:
            1st element is ON/OFF state for CPU0,
            2nd element is ON/OFF state for CPU1
    '''
    cpu0_state, cpu1_state = cpu_pair

    ##
    # NOTE:
    # ordering matters here, since we need to turn on the
    # last cpu that was turned off to avoid the condition
    # where both cpus are off!
    ##
    if cpu0_state is '1':
        _write_to_sysfs(_mk_cpu_sysfs_path(0), cpu0_state)
        _write_to_sysfs(_mk_cpu_sysfs_path(1), cpu1_state)
    else:
        _write_to_sysfs(_mk_cpu_sysfs_path(1), cpu1_state)
        _write_to_sysfs(_mk_cpu_sysfs_path(0), cpu0_state)

    # read and print part of dmesg
    with output_widget:
        d_mesg = check_output("dmesg | tail -4", shell=True)
        for line in d_mesg.splitlines():
            print(line.decode())


def _handle_cpu_imgs(cpu_img_pair):
    '''
    Handles output imgs for CPUs:
        `cpu_img_pair` is a tuple where:
            1st element is ON/OFF image for CPU0,
            2nd element is ON/OFF image for CPU1,
    '''
    for i, cpu in enumerate(cpu_monitor.children):
        cpu.value = cpu_img_pair[i]


def _on_button_press(btn_clicked):
    '''
        Handler for each button's click event
    '''
    # mutually exclusive buttons
    btn_mutex_map = {
        button_tags[0]: button_tags[1],
        button_tags[1]: button_tags[0]
    }

    output_widget.clear_output(wait=True)
    with output_widget:
        print('Button \'[{0}]\' clicked'.format(btn_clicked.description))

    # disable just pressed button
    btn_clicked.disabled = True

    if btn_clicked.description not in btn_mutex_map:
        # if 'both CPUs on' pressed, enable all buttons
        for b in buttons:
            b.disabled = False
    else:
        # else handle mutually exclusive buttons logic
        for b in buttons:
            if b.description == btn_mutex_map[btn_clicked.description]:
                b.disabled = False

    # handle given cpu action
    _handle_cpu_cntl(button_args[btn_clicked.description][0])

    # handle cpu monitor output images
    _handle_cpu_imgs(button_args[btn_clicked.description][1])


def _setup_buttons():
    '''
        Returns a list of "Button" instances
    '''
    btn_list = [Button(value=False,
                       disabled=False,
                       description=word,
                       button_style='primary',
                       on_click=_on_button_press,
                       layout=Layout(width='auto', height='80px'))
                for word in button_tags]

    for btn in btn_list:
        btn.on_click(_on_button_press)

    return btn_list


def run_demo():
    '''
        Demo entry point
    '''
    global buttons, output_widget, cpu_monitor
    buttons = _setup_buttons()
    output_widget = _setup_output_widget()
    cpu_monitor = _setup_cpu_monitor_widgets()
    buttons_vbox = _setup_buttons_container(buttons)
    display(buttons_vbox, output_widget, cpu_monitor)
