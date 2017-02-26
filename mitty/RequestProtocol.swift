//
//  Request.swift
//  mitty
//
//  Created by gridscale on 2017/01/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    func upload(req: Request)
    func propose(req: Request, proposal: Proposal)
    func accept(req: Request, proposal: Proposal)
    func approve(req: Request, proposal: Proposal)
}
