#import "@preview/tablex:0.0.5": tablex, cellx, rowspanx, colspanx
#import "./docs/resources/transaction.typ": *

#let image-background = image("./assets/images/background-1.jpg", height: 100%, fit: "cover")
#let image-foreground = image(
  "./assets/images/Logo-Anastasia-Labs-V-Color02.png",
  width: 100%,
  fit: "contain",
)
#let image-header = image(
  "./assets/images/Logo-Anastasia-Labs-V-Color01.png",
  height: 75%,
  fit: "contain",
)
#let fund-link = link(
  "https://projectcatalyst.io/funds/10/f10-osde-open-source-dev-ecosystem/anastasia-labs-the-trifecta-of-data-structures-merkle-trees-tries-and-linked-lists-for-cutting-edge-contracts",
)[Catalyst Proposal]
#let git-link = link("https://github.com/Anastasia-Labs/data-structures")[Main Github Repo]

#set page(
  background: image-background,
  paper: "a4",
  margin: (left: 20mm, right: 20mm, top: 40mm, bottom: 30mm),
)

// Set default text style
#set text(15pt, font: "Montserrat")

#v(3cm) // Add vertical space

#align(center)[
  #box(width: 60%, stroke: none, image-foreground)
]

#v(1cm) // Add vertical space

// Set text style for the report title
#set text(20pt, fill: white)

// Center-align the report title
#align(center)[#strong[Linear Vesting]]
#align(center)[#strong[Project Design Specification]]

#v(5cm)

// Set text style for project details
#set text(13pt, fill: white)

// Reset text style to default
#set text(fill: luma(0%))

// Display project details
#show link: underline
#set terms(separator: [: ], hanging-indent: 18mm)

#set par(justify: true)
#set page(
  paper: "a4",
  margin: (left: 20mm, right: 20mm, top: 40mm, bottom: 35mm),
  background: none,
  header: [
    #align(right)[
      #image(
        "./assets/images/Logo-Anastasia-Labs-V-Color01.png",
        width: 25%,
        fit: "contain",
      )
    ]
    #v(-0.5cm)
    #line(length: 100%, stroke: 0.5pt)
  ],
)

#v(20mm)
#show link: underline
#show outline.entry.where(level: 1): it => {
  v(6mm, weak: true)
  strong(it)
}

#outline(depth: 3, indent: 1em)
#pagebreak()
#set text(size: 11pt) // Reset text size to 10pt
#set page(footer: [
  #line(length: 100%, stroke: 0.5pt)
  #v(-3mm)
  #align(center)[
    #set text(size: 11pt, fill: black)
    *Anastasia Labs –*
    #set text(size: 11pt, fill: gray)
    *Linear Vesting*
    #v(-3mm)
    Getting Started Document
    #v(-3mm)
  ]
  #v(-6mm)
  #align(right)[
    #counter(page).display("1/1", both: true)
  ]
])

// Initialize page counter
#counter(page).update(1)
#v(100pt)
// Display project details
// #set terms(separator:[: ],hanging-indent: 18mm)
// #align(center)[
//   #set text(size: 20pt)
//   #strong[Upgradable Multi-Signature Contract]]
#v(20pt)
\

#set heading(numbering: "1.")
#show heading: set text(rgb("#c41112"))
#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 30mm, bottom: 30mm),
)

#set text(font: "New Computer Modern", size: 11pt)

#set heading(numbering: "1.")

#show heading: set block(above: 1.4em, below: 0.7em)

= Getting Started with Linear Vesting

== Table of Contents

#outline(indent: true)

= Introduction

The Linear Vesting contract provides a mechanism for releasing Cardano Native
Tokens gradually over a specified timeframe, with customization options to fit
different requirements. It's useful for token compensation, DAO treasury
vesting, and installment payment plans.

= Getting Started

== Prerequisites

Before you begin, ensure you have #link("https://nixos.org")[Nix] installed on
your system. Nix is used for package management and to provide a consistent
development environment. If you don't have Nix installed, you can do so by
running the following command:

=== Official option

#link("https://nixos.org/download.html")[Nix]

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

=== Preferred option
#link("https://zero-to-nix.com/concepts/nix-installer")[Determinate Systems]
text curl --proto '=https' --tlsv1.2 -sSf -L
https://install.determinate.systems/nix | sh -s -- install

Make sure to enable #link("https://nixos.wiki/wiki/Flakes#Enable_flakes")[Nix Flakes] by
editing either ~/.config/nix/nix.conf or /etc/nix/nix.conf on your machine and
add the following configuration entries: text experimental-features =
nix-command flakes ca-derivations allow-import-from-derivation = true

Optionally, to improve build speed, it is possible to set up binary caches by
adding additional configuration entries: text substituters =
https://cache.nixos.org https://cache.iog.io https://cache.zw3rk.com
trusted-public-keys =
cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=
loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk=

To facilitate seamlessly moving between directories and associated Nix
development shells we use #link("https://direnv.net")[direnv] and #link("https://github.com/nix-community/nix-direnv")[nix-direnv]:
Your shell and editors should pick up on the .envrc files in different
directories and prepare the environment accordingly. Use direnv allow to enable
the direnv environment and direnv reload to reload it when necessary. Otherwise,
the .envrc file contains a proper Nix target which will be used with the nix
develop --accept-flake-config command. To install both using `nixpkgs`: `nix
profile install nixpkgs#direnv` `profile install nixpkgs#nix-direnv`

= Building and Testing
Once Nix is installed, you should be able to seamlessly use the repository to
develop, build and run packages. Download the Git repository: text git clone
https://github.com/Anastasia-Labs/linear-vesting.git

Navigate to the repository directory: text cd linear-vesting

Activate the development environment with Nix: text nix develop
--accept-flake-config

Or text make shell

Please be patient when building nix development environment for the first time,
as it may take a very long time. Subsequent builds should be faster.
Additionally, when you run nix run .`#help` you'll get a list of scripts you can
run, the Github CI (nix flake check) is setup in a way where it checks the
project builds successfully, haskell format is done correctly, and commit
message follows conventional commits. Before pushing you should run cabal run,
nix run .`#haskellFormat` (automatically formats all haskell files, including
cabal), if you want to commit a correct format message you can run cz commit
Build: text make build

Execute the test suite: text make test

= Understanding the Linear Vesting Contract
text pvalidateVestingScript :: Term s (PVestingDatum :--> PVestingRedeemer :-->
PScriptContext :--> PUnit)

The linear vesting validator is not a parameterized one. All its customization
needs are fulfilled by the datum (VestingDatum) of the locked UTxO.== Datum text
data VestingDatum = VestingDatum { beneficiary :: Address , vestingAsset ::
AssetClass , totalVestingQty :: Integer , vestingPeriodStart :: Integer ,
vestingPeriodEnd :: Integer , firstUnlockPossibleAfter :: Integer ,
totalInstallments :: Integer }

#tablex(
  columns: (auto, auto, 1fr),
  align: left,
  inset: 5pt,
  [Field],
  [Type],
  [Description],
  [beneficiary],
  [Address],
  [The address of the recipient who will receive the vested assets.],
  [vestingAsset],
  [AssetClass],
  [Identifies the specific asset being vested, typically represented by a policy ID
    and asset name.],
  [totalVestingQty],
  [Integer],
  [The total quantity of the asset to be vested over the entire vesting period.],
  [vestingPeriodStart],
  [Integer],
  [The timestamp marking the beginning of the vesting period.],
  [vestingPeriodEnd],
  [Integer],
  [The timestamp marking the end of the vesting period.],
  [firstUnlockPossibleAfter],
  [Integer],
  [The earliest timestamp at which the first portion of the vested assets can be
    claimed.],
  [totalInstallments],
  [Integer],
  [The number of separate releases or "unlocks" over which the total vesting
    quantity will be distributed.],
)
== Redeemer
text data VestingRedeemer= PartialUnlock | FullUnlock

=== Partial Unlock
When using the PartialUnlock redeemer, the following conditions and actions
apply: Timing: The transaction can only be validated after
firstUnlockPossibleAfter and before vestingPeriodEnd. Claim Amount: The
beneficiary can claim a portion of the vested assets. The claimable amount is
proportional to the time elapsed since vestingPeriodStart. Remaining Assets: Any
unclaimed assets must be returned to the validator address. Datum Preservation:
The original datum must remain intact for the returned assets.==== Validation
Requirements: The transaction must occur within the specified time window,
between firstUnlockPossibleAfter and vestingPeriodEnd. The claimed amount must
not exceed the proportionally vested amount. Unclaimed assets must be properly
returned with the original datum. By using the PartialUnlock redeemer, the
beneficiary initiates a partial claim of their vested assets while ensuring the
integrity of the vesting schedule and the security of any remaining assets.===
Full Unlock When the FullUnlock redeemer is used: It allows the beneficiary to
claim the entire remaining balance of vested assets from the UTxO. This redeemer
is only valid for transactions submitted after the vestingPeriodEnd.====
Validation Requirements: The current time is greater than vestingPeriodEnd. The
entire remaining balance of vested assets is being claimed. The beneficiary's
address matches the one specified in the datum. Using the FullUnlock redeemer
signals the intent to complete the vesting process and withdraw all remaining
assets, but it can only be successfully applied once the vesting period has
concluded.= Exporting Plutarch Scripts Once the script is compiled, locate the
generated serialised .json file in your project's output directory. This file
contains the bytecode that will be deployed on the Cardano blockchain. You can
copy and paste the contents of this file into offchain directory.= Building and
Testing OffChain== Install package text npm install
`@anastasia-labs/direct-offer-offchain`

or text pnpm install `@anastasia-labs/direct-offer-offchain`

== Local Build
In main directory text pnpm run build

== Test framework
#link(
  "https://github.com/vitest-dev/vitest",
)[https://github.com/vitest-dev/vitest]
== Running Tests
text pnpm test

= Transaction Building
== Lock Assets at Vesting Contract
A predefined amount of tokens is sent to smart contract. This is total amount to
be vested. The start date (e.g., vestingPeriodStart) , end date (e.g.,
vestingPeriodEnd) of vesting period , the number of installments (e.g.,
totalInstallments), first installment date (e.g., firstUnlockPossibleAfter), and
beneficiary's address is specified which is only address that can claim vested
tokens. All these fields are specified in vestingDatum.
#image("./assets/gifs/lock_tokens.gif", width: 80%)
== Collect token with Partial-Unlock Redeemer
With PartialUnlock redeemer after firstUnlockPossibleAfter and before
vestingPeriodEnd, beneficiary can claim vested asset in proportion to time that
has passed after vestingPeriodStart. The remaining assets needs to be sent back
to validator address with original datum intact otherwise validation will fail.
#image("./assets/gifs/partialUnlock.gif", width: 80%)
== Collect all tokens with Full-Unlock Redeemer
After vestingPeriodEnd, beneficiary can claim entire remaining balance at UTxO
using FullUnlock redeemer.
#image("./assets/gifs/fullUnlock.gif", width: 80%)
= Additional Resources
== Demeter Workspace
To provide seamless experience for running and trying out our application click
workspace button below this will start workspace in Demeter with our repository
code automatically cloned.
#link(
  "https://demeter.run/code?repository=https://github.com/Anastasia-Labs/linear-vesting&template=plutus&size=large",
)[Code in Workspace]
There is also #link(
  "https://anastasia-labs.github.io/production-grade-dapps/linear_vesting",
)[GitBook] available for more details.