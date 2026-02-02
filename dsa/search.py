"""
DSA Integration: Linear Search vs Dictionary Lookup Performance Comparison

This module compares two approaches to finding transactions by ID:
    1. Linear Search - O(n) time complexity, iterate through list
    2. Dictionary Lookup - O(1) time complexity, hash table access
    """

    import json
    import time
    import os


    def load_transactions(json_file):
            """Load transactions from JSON file"""
                try:
                            with open(json_file, 'r') as f:
                                            return json.load(f)
                                            except FileNotFoundError:
                                                        print(f"✗ File not found: {json_file}")
                                                                return []
                                                                except json.JSONDecodeError:
                                                                            print(f"✗ Invalid JSON: {json_file}")
                                                                                    return []


                                                                                def linear_search(transactions, target_id):
                                                                                        """
                                                                                            Linear Search - O(n) complexity
                                                                                                Iterate through list sequentially until target is found
                                                                                                    """
                                                                                                        for tx in transactions:
                                                                                                                    if tx['id'] == target_id:
                                                                                                                                    return tx
                                                                                                                                    return None


                                                                                                                                def dictionary_lookup(transactions_dict, target_id):
                                                                                                                                        """
                                                                                                                                            Dictionary Lookup - O(1) complexity
                                                                                                                                                Direct hash table access using transaction ID as key
                                                                                                                                                    """
                                                                                                                                                        return transactions_dict.get(target_id)


                                                                                                                                                    def create_transaction_dict(transactions):
                                                                                                                                                            """Convert list to dictionary for O(1) lookup"""
                                                                                                                                                                return {tx['id']: tx for tx in transactions}


                                                                                                                                                            def benchmark_search(transactions, test_ids, num_iterations=100):
                                                                                                                                                                    """
                                                                                                                                                                        Benchmark both search methods
                                                                                                                                                                            """
                                                                                                                                                                                print("\n" + "="*80)
                                                                                                                                                                                    print("DSA INTEGRATION: SEARCH ALGORITHM COMPARISON")
                                                                                                                                                                                        print("="*80)
