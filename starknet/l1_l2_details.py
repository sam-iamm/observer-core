from starkware.starknet.compiler.compile import \
    get_selector_from_name

print("L1 Address as Felt", int("0x66e453faf0f7ce1a4aa1e03328213bdcb793c24c", 16))

print("L2 Address as Felt", int("0x046c3bac376724a5548735c42f97700456f257207a3e204b6a931069a9e0c29c", 16)) #
print("L2 Selector", get_selector_from_name('post_uni_v3_oracle_update'))