# Getting Started with Linear Vesting

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Building and Testing](#building-and-testing)
4. [Understanding the Linear Vesting Contract](#understanding-the-linear-vesting-contract)
5. [Exporting Plutarch Scripts](#exporting-plutarch-scripts)
6. [Transaction Building](#transaction-building)
7. [Contract API Endpoints](#contract-api-endpoints)
8. [Additional Resources](#additional-resources)
9. [Contributing](#contributing)
10. [License](#license)

# Linear Vesting Contract - Getting Started

## Introduction

The Linear Vesting contract provides a mechanism for releasing Cardano Native Tokens gradually over a specified timeframe. It's useful for token compensation, DAO treasury vesting, and installment payment plans.

## Getting Started

### Prerequisites

Before you begin, ensure you have [Nix](https://nixos.org) installed on your system. Nix is used for package management and to provide a consistent development environment. If you don't have Nix installed, you can do so by running the following command:

#### Official option

[Nix](https://nixos.org/download.html)

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

#### Preferred option

[Determinate Systems](https://zero-to-nix.com/concepts/nix-installer)

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Make sure to enable [Nix Flakes](https://nixos.wiki/wiki/Flakes#Enable_flakes) by editing either `~/.config/nix/nix.conf` or `/etc/nix/nix.conf` on
your machine and add the following configuration entries:

```yaml
experimental-features = nix-command flakes ca-derivations
allow-import-from-derivation = true
```

Optionally, to improve build speed, it is possible to set up binary caches by adding additional configuration entries:

```yaml
substituters = https://cache.nixos.org https://cache.iog.io https://cache.zw3rk.com
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk=
```

To facilitate seamlessly moving between directories and associated Nix development shells we use [direnv](https://direnv.net) and [nix-direnv](https://github.com/nix-community/nix-direnv):

Your shell and editors should pick up on the `.envrc` files in different directories and prepare the environment accordingly. Use `direnv allow` to enable the direnv environment and `direnv reload` to reload it when necessary. Otherwise, the `.envrc` file contains a proper Nix target which will be used with the `nix develop --accept-flake-config` command.

To install both using `nixpkgs`:

```sh
nix profile install nixpkgs#direnv
nix profile install nixpkgs#nix-direnv
```

## Building and Testing

Once Nix is installed, you should be able to seamlessly use the repository to
develop, build and run packages.

Download the Git repository:

```sh
git clone https://github.com/Anastasia-Labs/linear-vesting.git
```

Fork the Git repository:
--add actions--

Navigate to the repository directory:

```sh
cd linear-vesting
```

Activate the development environment with Nix:

```sh
nix develop --accept-flake-config
```

Or

```sh
make shell
```

Please be patient when building nix development environment for the first time, as it may take a very long time. Subsequent builds should be faster. Additionally, when you run `nix run .#help` you'll get a list of scripts you can run, the Github CI (nix flake check) is setup in a way where it checks the project builds successfully, haskell format is done correctly, and commit message follows conventional commits. Before pushing you should run `cabal run` , `nix run .#haskellFormat` (automatically formats all haskell files, including cabal), if you want to commit a correct format message you can run `cz commit`

Build:

```sh
make build
```

Execute the test suite:

```sh
make test
```

## Using the Contract

1. Lock Tokens:

- Send tokens to the smart contract
- Set vesting period start and end dates
- Set number of installments and first unlock date
- Specify beneficiary address

2. Claim Tokens:

- Beneficiary can claim vested tokens between start and end dates
- Use `PartialUnlock` redeemer for partial claims
- Use `FullUnlock` redeemer after vesting period ends

## Understanding the Linear Vesting Contract

```hs
pvalidateVestingScript :: Term s (PVestingDatum :--> PVestingRedeemer :--> PScriptContext :--> PUnit)
```

The linear vesting validator does not have parameters set. All its customization needs are fulfilled by the datum (`VestingDatum`) of the locked UTxO.

### Datum

```hs
data VestingDatum = VestingDatum
  { beneficiary :: Address
  , vestingAsset :: AssetClass
  , totalVestingQty :: Integer
  , vestingPeriodStart :: Integer
  , vestingPeriodEnd :: Integer
  , firstUnlockPossibleAfter :: Integer
  , totalInstallments :: Integer
  }
```

#### beneficiary

- **Type**: `Address`
- **Description**: The address of the recipient who will receive the vested assets.

#### vestingAsset

- **Type**: AssetClass
- **Description**: Identifies the specific asset being vested, typically represented by a policy ID and asset name.

#### totalVestingQty

- **Type**: Integer
- **Description**: The total quantity of the asset to be vested over the entire vesting period.

#### vestingPeriodStart

- **Type**: Integer
- **Description**: The timestamp marking the beginning of the vesting period.

#### vestingPeriodEnd

- **Type**: Integer
- **Description**: The timestamp marking the end of the vesting period.

#### firstUnlockPossibleAfter

- **Type**: Integer
- **Description**: The earliest timestamp at which the first portion of the vested assets can be claimed.

#### totalInstallments

- **Type**: Integer
- **Description**: The number of separate releases or "unlocks" over which the total vesting quantity will be distributed.

### Redeemer

```hs
data VestingRedeemer
  = PartialUnlock
  | FullUnlock
```

### Partial Unlock

When using the `PartialUnlock` redeemer, the following conditions and actions apply:

- Timing: The transaction can only be validated after `firstUnlockPossibleAfter` and before `vestingPeriodEnd`.

- Claim Amount: The beneficiary can claim a portion of the vested assets. The claimable amount is proportional to the time elapsed since `vestingPeriodStart`.

- Remaining Assets: Any unclaimed assets must be returned to the validator address.

- Datum Preservation: The original datum must remain intact for the returned assets.

#### Validation Requirements:

1. The transaction must occur within the specified time window, between `firstUnlockPossibleAfter` and `vestingPeriodEnd`..
2. The claimed amount must not exceed the proportionally vested amount.
3. Unclaimed assets must be properly returned with the original datum.

By using the `PartialUnlock` redeemer, the beneficiary initiates a partial claim of their vested assets while ensuring the integrity of the vesting schedule and the security of any remaining assets.

### Full Unlock

When the `FullUnlock` redeemer is used:

1. It allows the beneficiary to claim the entire remaining balance of vested assets from the UTxO.
2. This redeemer is only valid for transactions submitted after the `vestingPeriodEnd`.

#### Validation Requirements:

1. The current time is greater than `vestingPeriodEnd`.

2. The entire remaining balance of vested assets is being claimed.

3. The beneficiary's address matches the one specified in the datum.

Using the `FullUnlock` redeemer signals the intent to complete the vesting process and withdraw all remaining assets, but it can only be successfully applied once the vesting period has concluded.

## Exporting Plutarch Scripts

Once the script is compiled, locate the generated serialised .json file in your project’s output directory. This file contains the bytecode that will be deployed on the Cardano blockchain. You can copy and paste the contents of the file into the offchain directory.

## Transaction Building

// add building and testing for off chain seperately

### Lock Assets at the Vesting Contract

A predefined amount of tokens is sent to the smart contract. This is the total amount to be vested.
The start date (e.g., `vestingPeriodStart`) , end date (e.g., `vestingPeriodEnd`) of the vesting period ,
the number of installments (e.g., `totalInstallments`), first installment date (e.g., `firstUnlockPossibleAfter`),
and the beneficiary's address is specified, which is the only address that can claim the vested tokens. All these fields are specified in the `vestingDatum`.

![lock-tokens](/assets/gifs/lock_tokens.gif)

### Collect token with Partial-Unlock Redeemer

With `PartialUnlock` redeemer, after `firstUnlockPossibleAfter` and before `vestingPeriodEnd`, beneficiary can claim the vested asset in proportion to the time that has passed after `vestingPeriodStart`. The remaining assets needs to be sent back to the validator address with the original datum intact otherwise the validation will fail.

![lock-tokens](/assets/gifs/partialUnlock.gif)

### Collect all tokens with Full-Unlock Redeemer

// To be done

## Contract API endpoint

// Elaborate about how Maestro API works

## Additional Resources

// Explain about demeter
// link to Anastasia Labs git book

- Use the Demeter Workspace for a seamless development experience.

## License

© 2023 Anastasia Labs. All code is licensed under MIT License.
