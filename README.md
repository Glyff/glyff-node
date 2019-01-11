## Glyff Client

Official golang implementation of the Ethereum-based Glyff protocol.

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/glyff/lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


## Building the source

For prerequisites and detailed build instructions please read the official
Glyff-node [Installation
Instructions](https://github.com/Glyff/glyff-node/wiki/Building-Glyff)
on the wiki. Additionally, glyff depends on JPMorgan Chase's ZSL on Quorum,
with its own set of [build
requirements](https://github.com/jpmorganchase/zsl-q#building).

Building glyff requires both a Go (version 1.8 or later) and a C/++ compiler.
You can install them using your favourite package manager. Once the
dependencies are installed, run

    make glyff


## Executables

The glyff project executable is found in the `cmd` directory.

| Command    | Description |
|:----------:|-------------|
| **`glyff`** | Our main Glyff CLI client. It is the entry point into the Glyff network (main-, test- or private net), capable of running as a full node (default) archive node (retaining all historical state) or a light node (retrieving data live). It can be used by other processes as a gateway into the Glyff network via JSON RPC endpoints exposed on top of HTTP, WebSocket and/or IPC transports. `glyff --help` for command line options. |


## Running glyff

### Full node on the Glyff private testnet

At present, Glyff runs as a permissioned private testnet, which means partecipants have to be whitelisted before connecting to the official seed nodes.  Request access to the private testnet [here](https://glyff.io/status.html). The private testnet works with toy funds, i.e. coins mined will have NO real-world value. 

To enable simple interaction withe Glyff private testnet, such as : create accounts; transfer funds; deploy and interact with contracts. For this particular use-case
the user doesn't care about years-old historical data, so we can fast-sync quickly to the current
state of the network. To do so:

```
$ glyff console
```

This command will:

 * Start glyff in fast sync mode (default, can be changed with the `--syncmode` flag), causing it to
   download more data in exchange for avoiding processing the entire history of the Glyff network,
   which is very CPU intensive.
 * Start up Glyff's built-in interactive [JavaScript console](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console),
   (via the trailing `console` subcommand) through which you can invoke all official [`web3` methods](https://github.com/ethereum/wiki/wiki/JavaScript-API)
   as well as Glyff's own [management APIs](https://github.com/ethereum/go-ethereum/wiki/Management-APIs).
   This too is optional and if you leave it out you can always attach to an already running Glyff instance
   with `glyff attach`.



### Configuration

As an alternative to passing the numerous flags to the `glyff` binary, you can also pass a configuration file via:

```
$ glyff --config /path/to/your_config.toml
```

To get an idea how the file should look like you can use the `dumpconfig` subcommand to export your existing configuration:

```
$ glyff --your-favourite-flags dumpconfig
```

#### Docker quick start

One of the quickest ways to get Glyff up and running on your machine is by using Docker:

```
docker run -d --name glyff-node -v /Users/alice/glyff:/root \
           -p 8545:8545 -p 30303:30303 \
           glyff/glyff
```

This will start glyff in fast-sync mode with a DB memory allowance of 1GB just as the above command does.  It will also create a persistent volume in your home directory for saving your blockchain as well as map the default ports. There is also an `alpine` tag available for a slim version of the image.

Do not forget `--rpcaddr 0.0.0.0`, if you want to access RPC from other containers and/or hosts. By default, `glyff` binds to the local interface and RPC endpoints is not accessible from the outside.

### Programatically interfacing Glyff nodes

As a developer, sooner rather than later you'll want to start interacting with Glyff and the Glyff
network via your own programs and not manually through the console. To aid this, Glyff has built in
support for a JSON-RPC based APIs ([standard APIs](https://github.com/ethereum/wiki/wiki/JSON-RPC) and
[Glyff specific APIs](https://github.com/ethereum/go-ethereum/wiki/Management-APIs)). These can be
exposed via HTTP, WebSockets and IPC (unix sockets on unix based platforms, and named pipes on Windows).

The IPC interface is enabled by default and exposes all the APIs supported by Glyff, whereas the HTTP
and WS interfaces need to manually be enabled and only expose a subset of APIs due to security reasons.
These can be turned on/off and configured as you'd expect.

HTTP based JSON-RPC API options:

  * `--rpc` Enable the HTTP-RPC server
  * `--rpcaddr` HTTP-RPC server listening interface (default: "localhost")
  * `--rpcport` HTTP-RPC server listening port (default: 8545)
  * `--rpcapi` API's offered over the HTTP-RPC interface (default: "eth,net,web3,zsl")
  * `--rpccorsdomain` Comma separated list of domains from which to accept cross origin requests (browser enforced)
  * `--ws` Enable the WS-RPC server
  * `--wsaddr` WS-RPC server listening interface (default: "localhost")
  * `--wsport` WS-RPC server listening port (default: 8546)
  * `--wsapi` API's offered over the WS-RPC interface (default: "eth,net,web3,zsl")
  * `--wsorigins` Origins from which to accept websockets requests
  * `--ipcdisable` Disable the IPC-RPC server
  * `--ipcapi` API's offered over the IPC-RPC interface (default: "admin,debug,eth,miner,net,personal,shh,txpool,web3")
  * `--ipcpath` Filename for IPC socket/pipe within the datadir (explicit paths escape it)

You'll need to use your own programming environments' capabilities (libraries, tools, etc) to connect
via HTTP, WS or IPC to a Glyff node configured with the above flags and you'll need to speak [JSON-RPC](http://www.jsonrpc.org/specification)
on all transports. You can reuse the same connection for multiple requests!

**Note: Please understand the security implications of opening up an HTTP/WS based transport before
doing so! Hackers on the internet are actively trying to subvert Glyff nodes with exposed APIs!
Further, all browser tabs can access locally running webservers, so malicious webpages could try to
subvert locally available APIs!**


## Contribution

Thank you for considering to help out with the source code! We welcome contributions from
anyone on the internet, and are grateful for even the smallest of fixes!

If you'd like to contribute to glyff, please fork, fix, commit and send a pull request
for the maintainers to review and merge into the main code base. If you wish to submit more
complex changes though, please check up with the core devs first on [our gitter channel](https://gitter.im/glyff/lobby)
to ensure those changes are in line with the general philosophy of the project and/or get some
early feedback which can make both your efforts much lighter as well as our review and merge
procedures quick and simple.

Please make sure your contributions adhere to our coding guidelines:

 * Code must adhere to the official Go [formatting](https://golang.org/doc/effective_go.html#formatting) guidelines (i.e. uses [gofmt](https://golang.org/cmd/gofmt/)).
 * Code must be documented adhering to the official Go [commentary](https://golang.org/doc/effective_go.html#commentary) guidelines.
 * Pull requests need to be based on and opened against the `master` branch.
 * Commit messages should be prefixed with the package(s) they modify.
   * E.g. "eth, rpc: make trace configs optional"

Please see the [Developers' Guide](https://github.com/ethereum/go-ethereum/wiki/Developers'-Guide)
for more details on configuring your environment, managing project dependencies and testing procedures.

## License

Glyff is a fork of the [Go-Ethereum](https://github.com/ethereum/go-ethereum/) client and library.
The glyff library (i.e. all code outside of the `cmd` directory) is licensed under the
[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html), also
included in our repository in the `COPYING.LESSER` file.

The glyff binaries (i.e. all code inside of the `cmd` directory) is licensed under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), also included
in our repository in the `COPYING` file.
