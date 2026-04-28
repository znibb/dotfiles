from __future__ import annotations
from ansible.plugins.callback.default import CallbackModule as DefaultCallbackModule

DOCUMENTATION = '''
name: role_context
type: stdout
short_description: Prefixes included role task names with the calling role name
description:
  - When a role includes another role via include_role, the included role's task
    names are prefixed with the calling role name.
extends_documentation_fragment:
  - default_callback
'''


class CallbackModule(DefaultCallbackModule):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'stdout'
    CALLBACK_NAME = 'role_context'

    def __init__(self):
        super().__init__()
        self._include_callers = {}

    def v2_playbook_on_task_start(self, task, is_conditional):
        if task.action in ('ansible.builtin.include_role', 'include_role'):
            included_name = task.args.get('name', '')
            if task._role and included_name:
                caller = task._role._role_name
                self._include_callers[included_name] = caller
                original_get_name = task.get_name
                task.get_name = lambda: f'{caller} - {original_get_name()}'
                super().v2_playbook_on_task_start(task, is_conditional)
                task.get_name = original_get_name
                return

        if task._role and task._role._role_name in self._include_callers:
            role_name = task._role._role_name
            caller = self._include_callers[role_name]
            original_get_name = task.get_name
            task.get_name = lambda: original_get_name().replace(
                f'{role_name} :', f'{caller} - {role_name} :'
            )
            super().v2_playbook_on_task_start(task, is_conditional)
            task.get_name = original_get_name
        else:
            super().v2_playbook_on_task_start(task, is_conditional)
