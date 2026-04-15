//
//  AdminRequestsViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import Foundation
import Combine
import Supabase


@MainActor
class AdminRequestsViewModel: ObservableObject {
    
    @Published var requests: [Booking] = []
    @Published var isLoading = false
    
    //MARK: Download all bookings
    func fetchRequests() async {
        isLoading = true
        do{
            let fetchedRequests: [Booking] = try await supabase
                .from("bookings").select().order("created_at", ascending: false).execute().value
            
            //sort by status
            self.requests = fetchedRequests.sorted{
                if $0.status == "pending" && $1.status != "pending" {return true}
                if $0.status != "pending" && $1.status == "pending" {return false}
                return false
            }
            
        }catch {
            print("ADMIN. Failed to fetch requests: \(error.localizedDescription)")
        }
        isLoading = false
        
    }
    
    //MARK: Approve request
    
    func approveRequest(bookingId: UUID) async {
        
        do{
            try await supabase
                .from("bookings").update(["status": "approved", "rejection_reason": nil])
                .eq("id", value: bookingId).execute()
            
            //refreshing local list of requests
            if let index = requests.firstIndex(where: {$0.id == bookingId }){
                requests[index].status = "approved"
                requests[index].rejectionReason = nil
            }
            
        }catch{
            print("ADMIN. Failed to approve request: \(error.localizedDescription)")
        }
        
    }
    
    //MARK: Reject request
    
    func rejectRequest(bookingId: UUID, reason: String) async {
        do{
            let finalReason = reason.trimmingCharacters(in: .whitespaces).isEmpty ? nil : reason
            
            try await supabase
                .from("bookings").update(["status": "rejected", "rejection_reason": finalReason])
                .eq("id", value: bookingId).execute()
            
            if let index = requests.firstIndex(where: { $0.id == bookingId }) {
                requests[index].status = "rejected"
                requests[index].rejectionReason = finalReason
            }
        }catch{
            print("ADMIN. Failed to reject request: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
}


