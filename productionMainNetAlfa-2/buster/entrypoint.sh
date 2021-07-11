#!/bin/bash

INITIAL_ACCOUNT_BALANCE="${BLUZELLE_INITIAL_ACCOUNT_BALANCE:-500000000000000}"

blzd init curium00 --chain-id bluzelle 2>&1 | jq .node_id
sed -i -e '/^##### advanced configuration options #####/a output = "json"' ~/.blzd/config/config.toml
sed -i -e 's/"bond_denom": "stake"/"bond_denom": "ubnt"/g' ~/.blzd/config/genesis.json
sed -i -e 's/"denom": "stake"/"denom": "ubnt"/g' ~/.blzd/config/genesis.json
sed -i -e 's/minimum-gas-prices = ""/minimum-gas-prices = "10.0ubnt"/g' ~/.blzd/config/app.toml
blzcli config chain-id bluzelle 
blzcli config output json 
blzcli config indent true 
blzcli config trust-node true
blzcli config keyring-backend test

blzcli keys add vuser
blzd add-genesis-account $(blzcli keys show vuser -a) ${INITIAL_ACCOUNT_BALANCE}ubnt
blzd gentx --name vuser --amount 10000000000000ubnt --keyring-backend test
echo "Bluzelle validator address:"
cat ~/.blzd/config/gentx/gentx-*.json | jq .value.msg[0].value.validator_address
blzd collect-gentxs

blzd start &
blzcli rest-server --laddr tcp://0.0.0.0:1317 &

# Get stdout and stderr output files
BLZ_PIDS="$(pidof blzd blzcli)"
for pid in ${BLZ_PIDS}; do
  TAIL_FILES="${TAIL_FILES} /proc/${pid}/fd/1 /proc/${pid}/fd/2"
done
echo "export BLZ_PROC_STD_DESCRIPTORS=\"${TAIL_FILES}\"" >> ~/.bashrc

source ~/.bashrc
exec $(eval echo "$@")
