//
//  SwiftSMTP+Convenience.swift
//  funico-smtp
//
//  Created by Damian Van de Kauter on 11/03/2026.
//

import FunicoCore

import SwiftSMTP
import SwiftHTML

extension SwiftSMTP.Mail {
    
    /// Creates a preformatted error email for a project.
    ///
    /// The email uses an HTML template when `SwiftHTML` is available; otherwise it
    /// falls back to a plain-text body. Priority is set to `.high` for critical
    /// severity and `.normal` otherwise.
    ///
    /// - Parameters:
    ///   - error: The error to describe in the email body.
    ///   - project: The project name to include in the subject and content.
    ///   - sender: The sender contact.
    ///   - receivers: One or more primary recipients.
    ///   - cc: Optional CC recipients.
    ///   - bcc: Optional BCC recipients.
    ///   - severity: The severity used to set email priority (defaults to `.critical`).
    /// - Returns: A configured `SwiftSMTP.Mail` instance ready to send.
    ///
    /// ```swift
    /// let mail = SwiftSMTP.Mail.error(
    ///     someError,
    ///     project: "Funico",
    ///     from: sender,
    ///     to: receiver,
    ///     severity: .critical
    /// )
    /// ```
    public static func error(
        _ error: Error, project: String,
        from sender: SwiftSMTP.Mail.Contact, to receivers: SwiftSMTP.Mail.Contact...,
        cc: SwiftSMTP.Mail.Receivers? = nil, bcc: SwiftSMTP.Mail.Receivers? = nil,
        severity: Severity = .critical
    ) -> Self {
        Self.error(error, project: project, from: sender, to: receivers, cc: cc, bcc: bcc, severity: severity)
    }
    
    /// Creates a preformatted error email for a project.
    ///
    /// The email uses an HTML template when `SwiftHTML` is available; otherwise it
    /// falls back to a plain-text body. Priority is set to `.high` for critical
    /// severity and `.normal` otherwise.
    ///
    /// - Parameters:
    ///   - error: The error to describe in the email body.
    ///   - project: The project name to include in the subject and content.
    ///   - sender: The sender contact.
    ///   - receivers: One or more primary recipients.
    ///   - cc: Optional CC recipients.
    ///   - bcc: Optional BCC recipients.
    ///   - severity: The severity used to set email priority (defaults to `.critical`).
    /// - Returns: A configured `SwiftSMTP.Mail` instance ready to send.
    ///
    /// ```swift
    /// let mail = SwiftSMTP.Mail.error(
    ///     someError,
    ///     project: "Funico",
    ///     from: sender,
    ///     to: receiver,
    ///     severity: .critical
    /// )
    /// ```
    public static func error(
        _ error: Error, project: String,
        from sender: SwiftSMTP.Mail.Contact, to receivers: [SwiftSMTP.Mail.Contact],
        cc: SwiftSMTP.Mail.Receivers? = nil, bcc: SwiftSMTP.Mail.Receivers? = nil,
        severity: Severity = .critical
    ) -> Self {
        var mail = Mail(
            from: sender, to: receivers, cc: cc, bcc: bcc,
            subject: "[\(project)] Foutmelding") {
                HTMLDocument {
                    Grid(role: .presentation, width: "100%", cellpadding: 0, cellspacing: 0, border: 0) {
                        GridRow {
                            GridCell(alignment: .center, attributes: ["style": "padding: 32px 16px;"]) {
                                Grid(role: .presentation, width: "600", cellpadding: 0, cellspacing: 0, border: 0) {
                                    GridRow {
                                        GridCell(attributes: [
                                            "style": "background: #FFFFFF; border: 1px solid #E6E8EF; border-radius: 16px; padding: 28px;"
                                        ]) {
                                            Text("\(project) foutmelding:")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(.hex("#1F2A44"))
                                            
                                            Spacer(height: 8)
                                            
                                            Text("Er is een fout opgetreden.")
                                                .font(.body)
                                                .foregroundColor(.hex("#3D4B66"))
                                            
                                            Spacer(height: 20)
                                            
                                            Div {
                                                Text("Foutdetails:")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.hex("#6B7385"))
                                                
                                                Spacer(height: 6)
                                                
                                                Text(error.localizedDescription)
                                                    .font(.body)
                                                    .foregroundColor(.hex("#B42318"))
                                                    .style(
                                                        .background("#FFF5F5"),
                                                        .padding("12px"),
                                                        .border("1px solid #F2B8B5"),
                                                        .borderRadius("10px")
                                                    )
                                            }
                                            
                                            Spacer(height: 50)
                                            
                                            Text("Als dit probleem zich blijft voordoen, neem dan contact op met de ontwikkelaar.")
                                                .font(.body)
                                                .foregroundColor(.hex("#3D4B66"))
                                            
                                            Spacer(height: 16)
                                            
                                            Text("Bedankt,")
                                                .font(.body)
                                                .foregroundColor(.hex("#3D4B66"))
                                            
                                            Text("Team Funico")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.hex("#1F2A44"))
                                            
                                            Spacer(height: 30)
                                        }
                                    }
                                }
                                .style(.width("100%"), .maxWidth("600px"))
                            }
                        }
                    }
                } head: {
                    Meta(.charset("utf-8"))
                    Meta(.name("viewport", content: "width=device-width, initial-scale=1"))
                    Title(project)
                }
                .language("nl")
                .style(.margin("0"), .padding("0"), .background("#F4F6FA"), .fontFamily("-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"))
            }
        mail.setPriority((severity == .critical) ? .high : .normal)
        
        return mail
    }
    
    /// Creates a preformatted success email for a project.
    ///
    /// The email uses an HTML template with green success styling.
    /// Priority is set to `.normal`.
    ///
    /// - Parameters:
    ///   - message: The success message to describe in the email body.
    ///   - project: The project name to include in the subject and content.
    ///   - sender: The sender contact.
    ///   - receivers: One or more primary recipients.
    ///   - cc: Optional CC recipients.
    ///   - bcc: Optional BCC recipients.
    /// - Returns: A configured `SwiftSMTP.Mail` instance ready to send.
    ///
    /// ```swift
    /// let mail = SwiftSMTP.Mail.success(
    ///     "De taak is succesvol voltooid.",
    ///     project: "Funico",
    ///     from: sender,
    ///     to: receiver
    /// )
    /// ```
    public static func success(
        _ message: String, project: String,
        from sender: SwiftSMTP.Mail.Contact, to receivers: SwiftSMTP.Mail.Contact...,
        cc: SwiftSMTP.Mail.Receivers? = nil, bcc: SwiftSMTP.Mail.Receivers? = nil
    ) -> Self {
        Self.success(message, project: project, from: sender, to: receivers, cc: cc, bcc: bcc)
    }
    
    /// Creates a preformatted success email for a project.
    ///
    /// The email uses an HTML template with green success styling.
    /// Priority is set to `.normal`.
    ///
    /// - Parameters:
    ///   - message: The success message to describe in the email body.
    ///   - project: The project name to include in the subject and content.
    ///   - sender: The sender contact.
    ///   - receivers: One or more primary recipients.
    ///   - cc: Optional CC recipients.
    ///   - bcc: Optional BCC recipients.
    /// - Returns: A configured `SwiftSMTP.Mail` instance ready to send.
    ///
    /// ```swift
    /// let mail = SwiftSMTP.Mail.success(
    ///     "De taak is succesvol voltooid.",
    ///     project: "Funico",
    ///     from: sender,
    ///     to: receiver
    /// )
    /// ```
    public static func success(
        _ message: String, project: String,
        from sender: SwiftSMTP.Mail.Contact, to receivers: [SwiftSMTP.Mail.Contact],
        cc: SwiftSMTP.Mail.Receivers? = nil, bcc: SwiftSMTP.Mail.Receivers? = nil
    ) -> Self {
        var mail = Mail(
            from: sender, to: receivers, cc: cc, bcc: bcc,
            subject: "[\(project)] Succesmelding") {
                HTMLDocument {
                    Grid(role: .presentation, width: "100%", cellpadding: 0, cellspacing: 0, border: 0) {
                        GridRow {
                            GridCell(alignment: .center, attributes: ["style": "padding: 32px 16px;"]) {
                                Grid(role: .presentation, width: "600", cellpadding: 0, cellspacing: 0, border: 0) {
                                    GridRow {
                                        GridCell(attributes: [
                                            "style": "background: #FFFFFF; border: 1px solid #D1FADF; border-radius: 16px; padding: 28px;"
                                        ]) {
                                            Text("\(project) succesmelding:")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(.hex("#054F31"))
                                            
                                            Spacer(height: 8)
                                            
                                            Text("De actie is succesvol uitgevoerd.")
                                                .font(.body)
                                                .foregroundColor(.hex("#3D4B66"))
                                            
                                            Spacer(height: 20)
                                            
                                            Div {
                                                Text("Details:")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.hex("#667085"))
                                                
                                                Spacer(height: 6)
                                                
                                                Text(message)
                                                    .font(.body)
                                                    .foregroundColor(.hex("#027A48"))
                                                    .style(
                                                        .background("#F6FEF9"),
                                                        .padding("12px"),
                                                        .border("1px solid #ABEFC6"),
                                                        .borderRadius("10px")
                                                    )
                                            }
                                            
                                            Spacer(height: 50)
                                            
                                            Text("Deze mail bevestigt dat de actie correct werd afgewerkt.")
                                                .font(.body)
                                                .foregroundColor(.hex("#3D4B66"))
                                            
                                            Spacer(height: 16)
                                            
                                            Text("Bedankt,")
                                                .font(.body)
                                                .foregroundColor(.hex("#3D4B66"))
                                            
                                            Text("Team Funico")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.hex("#1F2A44"))
                                            
                                            Spacer(height: 30)
                                        }
                                    }
                                }
                                .style(.width("100%"), .maxWidth("600px"))
                            }
                        }
                    }
                } head: {
                    Meta(.charset("utf-8"))
                    Meta(.name("viewport", content: "width=device-width, initial-scale=1"))
                    Title(project)
                }
                .language("nl")
                .style(.margin("0"), .padding("0"), .background("#F4F6FA"), .fontFamily("-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"))
            }
        mail.setPriority(.normal)
        
        return mail
    }
}
