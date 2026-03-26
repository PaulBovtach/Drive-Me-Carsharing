//
//  SupabaseManager.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: Secrets.supabaseURL)!,
    supabaseKey: Secrets.supabaseKey
)

