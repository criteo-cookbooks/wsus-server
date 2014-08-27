Wsus-server Cookbook
=============
Installs WSUS (Windows Server Update Services) and configure approved updates.


Requirements
------------
This cookbook requires Chef 11.10.0+.

### Platforms
* Windows Server 2008 (R1, R2)
* Windows Server 2012 (R1, R2)

### Cookbooks
The following cookbooks are required as noted:

* [powershell][powershell_cookbook]

    `wsus-server::freeze` and `wsus-server::synchronize` leverage the powershell_script resource and require powershell 4

* [windows][windows_cookbook]

    `wsus-server::install` leverages windows_package LWRP

* [iis][iis_cookbook]

    `wsus-server::install` requires iis setup with some useful features

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### wsus-server::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['wsus-server']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### wsus-server::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `wsus-server` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[wsus-server]"
  ]
}
```

Contributing
------------
1. Fork the [repository on Github][repository]
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: [Baptiste Courtois][author] (<b.courtois@criteo.com>)

```text
Copyright 2014, Criteo.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[author]:                   https://github.com/Annih
[repository]:               https://github.com/criteo-cookbooks/wsus-server
[iis_cookbook]:             https://community.opscode.com/cookbooks/iis
[powershell_cookbook]:      https://community.opscode.com/cookbooks/powershell
[windows_cookbook]:         https://community.opscode.com/cookbooks/windows/