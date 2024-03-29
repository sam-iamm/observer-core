%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func l1_contract() -> (l1_contract_address : felt):
end

# A mapping from oracle_id to its latest twap, last_updated_at values.
@storage_var
func uni_v3_oracles(oracle_id : felt) -> (res : (felt, felt)):
end

# Emitted after each oracle update
@event
func uni_v3_oracle_updated(
    twap : felt, last_updated_at : felt
):
end

# sets L1 address
@constructor
func constructor{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(l1_contract_address : felt):
    l1_contract.write(value=l1_contract_address)
    return ()
end

# Returns the l1 contract address
@view
func get_l1_contract_address{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}() -> (res : felt):
    let (l1_contract_address) = l1_contract.read()
    return (l1_contract_address)
end

# Returns the oracle data of the given oracle_id.
@view
func get_uni_v3_oracle_data{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(oracle_id : felt) -> (res : (felt, felt)):
    let (oracle_data) = uni_v3_oracles.read(oracle_id)
    return ((oracle_data[0], oracle_data[1]))
end

# Handler for new oracle updates from L1
@l1_handler
func post_uni_v3_oracle_update{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(from_address : felt, oracle_id : felt, twap : felt, last_updated_at : felt):
    let (l1_contract_address) = l1_contract.read()
    assert from_address = l1_contract_address

    uni_v3_oracles.write(oracle_id, (twap, last_updated_at))
    uni_v3_oracle_updated.emit(twap=twap, last_updated_at=last_updated_at)

    return ()
end