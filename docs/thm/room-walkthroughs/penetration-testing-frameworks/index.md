
---

# **Penetration Testing Frameworks TryHackMe Room Walkthrough**

---


### **Introduction**

A penetration testing framework is a structured methodology that guides security professionals through every stage of an engagement, from initial planning and scoping to exploitation, reporting, and remediation validation. Consider the analogy of a building inspector following a code-compliance checklist: the inspector does not wander through the building, hoping to notice problems. Instead, they follow a systematic process that ensures every structural element, electrical system, and fire safety measure is evaluated against a known standard. Penetration testing frameworks serve the same purpose for security assessments.

Relying on a structured methodology provides several benefits. It ensures **thoroughness** so that critical areas are not overlooked. It promotes **consistency** so that different testers on the same team produce comparable results. It supports **compliance** by aligning the assessment with regulatory requirements. It also improves **communication** because clients, auditors, and stakeholders can understand and trust a process grounded in a recognized standard.

### **Task 2: OSSTMM**

#### **Overview**

The phrase *“you can’t manage what you can’t measure”* reflects the core idea behind OSSTMM. In penetration testing, results are often subjective, but OSSTMM introduces a structured, metric-driven approach to make findings quantifiable and repeatable.

Developed by ISECOM, OSSTMM (v3) applies scientific principles to security testing, prioritizing measurable data over opinion. Instead of subjective risk ratings, it produces consistent, verifiable results.

It defines five security channels:

- **HUMSEC:** Human/social engineering risks
- **PHYSSEC:** Physical access controls
- **SPECSEC:** Wireless communications (Wi-Fi, Bluetooth, RFID)
- **COMSEC:** Telecommunications systems
- **DATASEC:** Network and application-layer services

Security is evaluated across all channels, since weaknesses in one area (e.g., physical access or social engineering) can bypass strong network defenses.

A key output is the **Risk Assessment Value (RAV)**, which measures the relationship between attack surface exposure and security controls. Higher values indicate greater risk, while values near zero suggest balanced controls and exposure.

---

#### **Phases: A Walkthrough**

Using a sample assessment of *FinVault Corp* (`10.0.113.0/24`, `portal.finvault-corp.thm`):

---

**Phase 1: Induction**

Identify and verify assets.

DNS and certificate analysis reveal subdomains like `vpn.finvault-corp.thm` and `mail.finvault-corp.thm`, which are confirmed as live systems.

---

**Phase 2: Interaction**

Engage and measure exposed services.

Services are fingerprinted, revealing 12 exposed services across 8 hosts, with 4 allowing unauthenticated access.

---

**Phase 3: Inquiry**

Test exploitability and privilege escalation.

An IDOR vulnerability is found in the portal, allowing access to other users’ data (~12,000 accounts).

---

**Phase 4: Intervention**

Contain, review, and test detection.

The issue is patched, related controls are reviewed, and a canary token is deployed to test detection.

---

**Closing Notes**

OSSTMM uses the STAR reporting format for consistent audit output. Its strength is producing repeatable, measurable results, but it is complex and time-intensive compared to frameworks like OWASP or NIST.

#### **Questions**

**What OSSTMM metric quantifies the balance between an organization's attack surface and its controls?**

```
Risk Assessment Values
```

**After completing Induction and Interaction, what phase comes next and what is its objective?**

```
Inquiry
```

### **Task 3: OWASP WSTG**

#### **Overview**

When testing a web application such as an online retail platform, there are many potential attack surfaces: authentication, search, shopping carts, payments, and order tracking. Without a structured approach, testers risk duplicating effort or missing entire vulnerability classes.

The OWASP Web Security Testing Guide (WSTG) addresses this by providing a comprehensive, community-driven framework for web application security testing. Unlike the OWASP Top Ten, which summarizes key risks, the WSTG offers detailed, actionable guidance across more than 90 test cases organized into twelve categories.

These categories cover the full web application attack surface:

- Information gathering
- Configuration and deployment management
- Identity and authentication
- Authorization and session management
- Input validation
- Error handling
- Cryptography
- Business logic
- Client-side testing
- API testing

Each test case is assigned an identifier (e.g., `WSTG-INPV-01`) and includes structured steps for testing specific vulnerabilities.

The WSTG follows a risk-based approach, prioritizing vulnerabilities based on impact and exploitability rather than simply listing them.

---

**Phases: Security Across the SDLC**

The WSTG integrates security testing throughout the Software Development Life Cycle (SDLC), rather than treating it as a single phase. Example: *ShopSecure Inc.*, building a customer portal.

---

**Phase 1: Planning (Before development)**

Security requirements are defined early, including compliance needs such as PCI DSS and measurable security objectives (e.g., vulnerability patch timelines).

---

**Phase 2: Design**

System architecture is reviewed before coding begins. Threat modeling identifies high-risk components like payment APIs, leading to early security controls such as input validation and rate limiting.

---

**Phase 3: Development**

Code is reviewed against WSTG test cases. For example, authentication logic is analyzed, revealing issues such as non-expiring password reset tokens.

---

**Phase 4: Deployment**

Security controls are validated in staging or production-like environments. This includes checking TLS configuration, default credentials, and exposed debug endpoints.

---

**Phase 5: Maintenance**

Security testing continues after release. When new features are added, relevant WSTG test cases are re-executed to ensure no regressions are introduced.

---

**Closing Notes**

The WSTG provides detailed, structured coverage of web application security testing through over 90 test cases. Its strength lies in its completeness and practical guidance, supported by continuous updates from the security community.

However, full execution can be time-consuming and resource-intensive. Some areas also require specialized expertise, and excessive reliance on the checklist can reduce critical analysis. Effective use of WSTG combines structured testing with professional judgment.

---

#### **Questions:**

**The WSTG organizes its test cases using a specific identifier format. What identifier would you look for to find test cases related to input validation?**

```
WSTG-INPV
```

**A development team has just finished coding a new feature and wants to check it against WSTG before deployment. Which SDLC-aligned phase number are they in?**

```
3
```

### **Task 4: NIST SP 800-115**

**Overview**

NIST Special Publication 800-115 (*Technical Guide to Information Security Testing and Assessment*) provides a structured framework for evaluating the security of information systems. Originally developed for U.S. federal agencies, it is widely used across both public and private sectors.

Unlike a dedicated penetration testing methodology, NIST SP 800-115 covers a broad range of assessment activities, including document reviews, log analysis, vulnerability assessments, and penetration testing. Penetration testing is treated as one component of a larger security assessment process.

The framework focuses on three primary objectives:

- Identifying vulnerabilities in systems and applications
- Validating the effectiveness of security controls
- Assessing exploitability through realistic attack scenarios

---

#### **Phases: A Walkthrough**

Example: Security assessment of *GovNet*, a federal agency network.

---

**Phase 1: Planning**

Define scope, objectives, and rules of engagement before testing begins.

For GovNet, this includes identifying in-scope systems, excluded environments, communication procedures, testing windows, and emergency stop conditions. The phase concludes with an approved test plan.

---

**Phase 2: Execution**

Active testing is performed using four technique categories:

- **Review Techniques** – Examine policies, configurations, and documentation.
- **Target Identification & Analysis** – Discover hosts, ports, and services.
- **Target Vulnerability Validation** – Confirm identified vulnerabilities are genuine and exploitable.
- **Penetration Testing** – Simulate attacks to determine real-world impact.

Example: A potential SQL injection is identified, validated manually, and then exploited to demonstrate access to sensitive records.

---

**Phase 3: Post-Testing**

Analyze findings, prioritize risks, and provide remediation guidance.

Findings are categorized by severity, mapped to affected controls, and accompanied by actionable recommendations.

---

**Closing Notes**

NIST SP 800-115 is valued for its flexibility, standardization, and strong credibility within government and regulated industries. Because it defines testing techniques rather than specific tools, it can be adapted to many environments.

However, it is guidance rather than a regulatory requirement and relies on skilled testers capable of performing activities ranging from document reviews to exploitation.

---

#### **Questions:**

**During the Execution phase, your vulnerability scanner flags 15 potential issues on a web application. Before attempting exploitation, which NIST SP 800-115 technique category should you apply to these findings?**

```
Target vulnerability validation
```

### **Task 5: PTES (Penetration Testing Execution Standard)**

**Overview**

PTES focuses on the complete penetration testing lifecycle, from initial client discussions to final reporting. Unlike frameworks that emphasize specific testing techniques or metrics, PTES provides a practical workflow that mirrors how real-world engagements are conducted.

Its strength lies in defining **how a penetration test progresses from start to finish**, making it particularly useful for junior penetration testers.

---

#### **Phases: A Walkthrough**

Example: Penetration test for *MedGuard Health*.

---

**Phase 1: Pre-Engagement Interactions**

Define scope, rules of engagement, testing windows, emergency contacts, and legal authorization.

Example scope:

```
10.10.0.0/16
records.medguard-health.thm
Wireless networks
```

This phase ensures all testing is authorized and clearly documented before work begins.

---

**Phase 2: Intelligence Gathering**

Collect information using passive and active reconnaissance.

Examples:

- LinkedIn employee enumeration
- Certificate Transparency logs
- Job postings
- DNS enumeration
- Network scanning

---

**Phase 3: Threat Modeling**

Identify valuable assets and likely attack paths.

Example:

- Compromise the patient portal
- Compromise an employee workstation and pivot internally

---

**Phase 4: Vulnerability Analysis**

Identify and validate vulnerabilities through automated and manual testing.

Examples:

- Outdated Apache Tomcat
- Missing workstation patches

---

**Phase 5: Exploitation**

Exploit confirmed vulnerabilities to demonstrate impact.

Examples:

- Gain a shell through a Tomcat vulnerability
- Deliver a phishing payload to an employee workstation

---

**Phase 6: Post-Exploitation**

Determine the business impact of successful compromise.

Examples:

- Access patient records
- Extract credentials
- Move laterally to sensitive systems

---

**Phase 7: Reporting**

Document findings for both technical and executive audiences.

The report should include:

- Business impact
- Evidence
- Reproduction steps
- Remediation recommendations

---

**Closing Notes**

PTES is valued for its practical, end-to-end approach and strong focus on scoping and legal authorization. It closely reflects how real penetration testing engagements are performed.

Its main drawback is that some technical guidance is outdated and should be supplemented with modern tools and techniques. Unlike OSSTMM, it does not provide quantitative security metrics.

---

#### **Questions:**

**Which PTES phase number specifically addresses defining the scope, rules of engagement, and legal authorization for a penetration test?**

```
1
```

#### **Task 6: ISSAF (Information Systems Security Assessment Framework)**

**Overview**

ISSAF is an open-source penetration testing framework developed by OISSG. Although it has not been actively maintained since around 2006, its methodology remains valuable for understanding how attackers progress through a target environment.

The framework covers:

- Network security
- Host security
- Web applications
- Databases
- Social engineering

Its primary value today lies in its **nine-step assessment model**, which closely mirrors the attacker lifecycle and Cyber Kill Chain concepts.

---

#### **Phases: A Walkthrough**

Example: Assessment of *TechBridge Solutions*.

---

**Phase 1: Planning and Preparation**

Define the scope, rules, constraints, and testing procedures.

Example scope:

```
Corporate network
Git server
Project management portal
```

The goal is to ensure the assessment is authorized and properly planned.

---

**Phase 2: Assessment**

The core of ISSAF consists of nine sequential steps:

1. **Information Gathering** – Collect OSINT and target information.
2. **Network Mapping** – Identify hosts, services, and topology.
3. **Vulnerability Identification** – Discover weaknesses.
4. **Penetration** – Gain initial access.
5. **Privilege Escalation** – Obtain elevated permissions.
6. **Further Enumeration** – Identify additional targets and assets.
7. **Lateral Movement** – Access other systems using compromised credentials.
8. **Maintaining Access** – Demonstrate persistence techniques.
9. **Covering Tracks** – Identify ways an attacker could evade detection.

The model progresses from reconnaissance to compromise, persistence, and stealth.

---

**Phase 3: Reporting and Cleanup**

Document findings, prioritize risks, remove test artifacts, and ensure no residual access remains.

Example:

- Critical finding: Unauthenticated Jenkins console
- Result: Access to source code repositories and sensitive credentials

---

**Closing Notes**

ISSAF's greatest strength is its clear attacker-focused methodology. The nine-step model provides an excellent framework for understanding how real-world intrusions develop.

Its main limitation is that it is no longer maintained, making its tool recommendations and technical procedures outdated. Modern testing should supplement ISSAF with frameworks such as PTES, OWASP WSTG, or current tool documentation.

---

#### **Answers**

**ISSAF's nine-step assessment model begins with information gathering. What is the ninth and final step?**

```
Covering tracks
```

### **Task 7 - MITRE ATT&CK**

**Overview**

MITRE ATT&CK (*Adversarial Tactics, Techniques, and Common Knowledge*) is a knowledge base of real-world adversary behavior maintained by MITRE Corporation.

Unlike PTES, OSSTMM, or NIST SP 800-115, ATT&CK does **not** describe how to conduct a penetration test. Instead, it provides a standardized way to describe and categorize attacker actions observed during testing or real-world incidents.

Its primary purpose is to help security teams understand, detect, and defend against adversary techniques.

---

#### **The ATT&CK Matrix**

ATT&CK is organized into a matrix consisting of:

**Tactics (The "Why")**

High-level attacker objectives, including:

- Initial Access
- Execution
- Persistence
- Privilege Escalation
- Defense Evasion
- Credential Access
- Discovery
- Lateral Movement
- Collection
- Command and Control
- Exfiltration
- Impact

---

**Techniques (The "How")**

Specific methods used to achieve a tactic.

Examples:

```
T1566 - Phishing
T1190 - Exploit Public-Facing Application
T1003 - OS Credential Dumping
T1550 - Use Alternate Authentication Material
T1213 - Data from Information Repositories
```

Many techniques also contain sub-techniques.

Example:

```
T1566.001 - Spearphishing Attachment
T1566.002 - Spearphishing Link
T1566.003 - Spearphishing via Service
```

Each ATT&CK entry includes descriptions, real-world usage examples, detection guidance, and mitigations.

---

**ATT&CK as a Complement**

ATT&CK complements penetration testing frameworks rather than replacing them.

- **PTES** → Defines how to perform the engagement.
- **ATT&CK** → Provides a common language for describing attacker behavior.

By mapping findings to ATT&CK IDs, penetration test reports become more useful for detection engineering, threat hunting, and defensive planning.

---

**Example Mapping**

| Engagement Finding | ATT&CK Technique |
| --- | --- |
| Phishing email payload | T1566.001 |
| Exploited Tomcat vulnerability | T1190 |
| Credential dumping | T1003 |
| Lateral movement with stolen credentials | T1550 |
| Accessed patient records database | T1213 |

This allows defenders to focus on detecting attacker behaviors, not just patching individual vulnerabilities.

---

**Closing Notes**

ATT&CK serves as a universal language for describing adversary behavior. It is widely used by penetration testers, threat hunters, incident responders, and detection engineers.

Its greatest strength is standardization: findings can be mapped directly to techniques observed in real-world attacks, providing context beyond individual vulnerabilities.

---

**Key Takeaway**

```
PTES = How to conduct a penetration test
MITRE ATT&CK = How to describe attacker behavior observed during the test
```

#### **Questions:**

- In the ATT&CK matrix, what do the columns represent?
    - tactics
- In the ATT&CK matrix, what do the rows within each column represent?
    - techniques
- You compromised a web server by exploiting an unpatched vulnerability in its public-facing application. What ATT&CK technique ID would you use to classify this finding?
    - T1190

### **Task 8 - Other Notable Frameworks**

**Overview**

Beyond core penetration testing and security frameworks like PTES, OWASP WSTG, OSSTMM, NIST SP 800-115, ISSAF, and MITRE ATT&CK, there are several specialized frameworks used depending on industry, platform, and compliance requirements.

These frameworks are typically domain-specific, meaning they are chosen based on the client’s environment rather than used universally.

---

#### **Frameworks**

**WASC Threat Classification**

A taxonomy for categorizing web application threats developed by the Web Application Security Consortium (WASC). It groups vulnerabilities into categories such as authentication issues, information disclosure, and abuse of functionality.

It is largely deprecated and has been replaced in practice by OWASP resources, but it still appears in legacy documentation.

---

**CSA Cloud Controls Matrix (CCM)**

A cloud security governance framework published by the Cloud Security Alliance.

It defines security controls across cloud environments, including identity management, data security, and infrastructure protection, and maps them to standards such as ISO 27001, NIST, and PCI DSS.

It is primarily used for **cloud security posture and compliance assessments**, not penetration testing.

---

**OWASP Mobile Application Security Testing Guide (MASTG)**

A testing framework maintained by OWASP Foundation for evaluating mobile application security (Android and iOS).

It covers:

- Secure data storage
- Cryptography
- Network communication
- Platform interaction
- Code quality

It is used alongside the Mobile Application Security Verification Standard (MASVS) to test mobile apps such as banking or healthcare applications.

---

**PCI DSS Penetration Testing Guidelines**

Defined under Requirement 11.4 of PCI DSS v4.0, this is a **mandatory regulatory framework** for organizations handling payment card data.

It requires:

- Regular penetration testing (at least annually)
- Testing after significant infrastructure changes
- Coverage of internal and external environments
- Validation of network segmentation controls

It applies to any organization processing, storing, or transmitting cardholder data.

---

**CBEST Framework**

A threat intelligence-led penetration testing framework developed by the Bank of England for UK financial institutions.

It focuses on simulating realistic attacker behavior based on intelligence about relevant threat actors, making it highly tailored to financial sector risk profiles.

---

#### **Comparison Summary**

- **WASC** → Legacy web vulnerability taxonomy
- **CSA CCM** → Cloud governance and compliance assessment
- **OWASP MASTG** → Mobile application security testing
- **PCI DSS PT Guidelines** → Mandatory payment card security testing
- **CBEST** → Threat-intelligence-driven financial sector testing

---

**Closing Notes**

Framework selection depends heavily on context, including industry, platform, and regulatory environment. Understanding these frameworks allows penetration testers to identify the correct methodology for a given engagement rather than relying on a single universal approach.

---

#### **Questions:**

**Your client is a European online retailer that processes credit card payments. Which framework governs the penetration testing requirements?**

```
PCI DSS Penetration Testing Guidelines
```

**Security assessment of an iOS banking app (local storage + API communication)?**

```
OWASP Mobile Application Security Testing Guide
```

**Cloud infrastructure controls assessment (AWS, not a pentest)?**

```
CSA Cloud Controls Matrix
```

### **Task 9 - Choosing the Right Framework**

**Overview**

By this stage, you are familiar with multiple penetration testing frameworks, each designed with a different focus. However, knowing what each framework does is not enough — the real challenge is selecting the right one for a given engagement.

Framework selection is one of the first practical decisions a penetration tester makes after receiving scope details. Much like a mechanic choosing tools based on the job, testers select frameworks based on environment, objectives, and constraints.

No single framework fits every situation. Instead, the choice depends on context.

---

**Selection Criteria**

#### **Engagement scope and target type**

The type of system being tested often determines the framework:

- Web applications → OWASP WSTG
- Mobile applications → OWASP MASTG
- Network / full-scope engagements → PTES or OSSTMM
- Multi-channel assessments (including human/physical) → OSSTMM

---

#### **Regulatory and compliance requirements**

Legal and industry obligations can override preference entirely:

- PCI DSS → mandatory for payment card environments
- CBEST → required for UK financial institutions
- NIST SP 800-115 → common in U.S. federal/government contexts

When regulations apply, compliance defines the framework.

---

#### **Need for measurable results**

When results must be comparable over time or between testers, quantitative frameworks are preferred.

OSSTMM is specifically designed for this through its Risk Assessment Values (RAV), enabling objective comparison across engagements.

---

#### **Team expertise and resources**

Framework choice must match team capability:

- OSSTMM → high complexity, metric-heavy
- CBEST → requires threat intelligence capability
- PTES → practical and widely accessible for standard engagements

---

#### **Scenario Practice**

**Scenario 1: Hospital assessment**

A hospital requires testing of a patient portal and internal network, with executive reporting and HIPAA compliance.

**Best choice:** PTES

- Provides full engagement lifecycle
- Supports both web and network testing
- Produces executive + technical reporting

Supplement: OWASP WSTG + MITRE ATT&CK mapping

---

**Scenario 2: UK bank assessment**

A London-based bank requires a regulatory penetration test with threat intelligence requirements.

**Best choice:** CBEST

- Mandatory for UK financial sector
- Includes threat-intel-led testing
- Approved by regulators

---

**Scenario 3: SaaS platform comparison over time**

A web-based SaaS platform requires repeatable testing across years and different teams.

**Best choice:** OSSTMM

- Enables measurable comparison via RAV
- Supports consistency across assessors
- Works well with OWASP WSTG for web testing

---

**Scenario 4: Fintech mobile + payments**

A company has Android and iOS banking apps handling card payments.

**Best choice:** OWASP MASTG + PCI DSS

- MASTG → mobile application security testing
- PCI DSS → regulatory compliance for card data

---

**Closing Notes**

Framework selection is rarely exclusive. Most real-world engagements combine a primary framework (for structure) with supporting frameworks (for compliance, platform coverage, or reporting enhancement).

The key skill is recognizing which framework applies based on scope, regulation, and objectives — and when multiple frameworks must be combined.

---

#### **Questions:**

**A U.S. federal agency needs a security assessment of its internal network with document review + active testing. Which framework fits best?**

```
NIST SP 800-115
```

**E-commerce company with web storefront + mobile app + payment processing system. Which frameworks apply?**

```
WSTG,MASTG,PCI DSS
```

### **Task 10 - Conclusion**

The flag is:

```
THM{pen-test-fr4m3work5}
```