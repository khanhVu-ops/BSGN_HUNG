//
//  PatientAppointmentViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 18/12/24.
//

import UIKit
import FirebaseAuth

class PatientAppointmentViewController: UIViewController {

    @IBOutlet weak var waitingLabel: UILabel!
    @IBOutlet weak var waitingImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var graduatedLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var symtomsLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var appointments: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitingLabel.isHidden = true
        waitingImageView.isHidden = true
        setup()

    }
    func setup() {
        GlobalService.shared.fetchAppointmentsWithPatientID(completion: { [weak self] appointments in
            guard let self = self else { return }
            self.appointments = []
            for appointment in appointments {
                if appointment.status == "accepted" || appointment.status == "Pending" {
                    self.appointments.append(appointment)
                    print("xxxxx")
                }
            }
            
            // Di chuyển logic kiểm tra vào đây
            DispatchQueue.main.async {
                if !(self.appointments.isEmpty) {
                    guard let appointment = self.appointments.first else { return }
                    if appointment.doctorID == "00" {
                        self.allHidden()
                        print("1=========1")
                    } else {
                        self.allVisible()
                        print("1=========2")
                        print(appointment)
                        self.nameLabel.text = appointment.doctorName
                        self.majorLabel.text = appointment.specialty
                        self.priceLabel.text = String(appointment.price)
                        GlobalService.shared.loadDoctorWithID(doctorID: appointment.doctorID) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let doctor):
                                self.workLabel.text = doctor.training_place
                                self.graduatedLabel.text = doctor.degree
                                self.avatarImageView.image = UIImage(named: doctor.avatar)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                } else {
                    self.allHidden()
                    self.waitingLabel.text = "Bạn chưa đặt lịch hẹn"
                    print("2=========1")
                    print(self.appointments)
                }
            }
        }, patient: Auth.auth().currentUser!.uid)
    }

    func getAppointment(appointment: Appointment) {

        if appointment.doctorID == "00" {
            allHidden()
        } else {
            allVisible()
            print(appointment)
            nameLabel.text = appointment.doctorName
            majorLabel.text = appointment.specialty
            priceLabel.text = String(appointment.price)
            GlobalService.shared.loadDoctorWithID(doctorID: appointment.doctorID) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let doctor):
                    self.workLabel.text = doctor.training_place
                    self.graduatedLabel.text = doctor.degree
                    self.avatarImageView.image = UIImage(named: doctor.avatar)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func allHidden() {
        symtomsLabel.isHidden = true
        cancelButton.isHidden = true
        nameLabel.isHidden = true
        majorLabel.isHidden = true
        priceLabel.isHidden = true
        workLabel.isHidden = true
        graduatedLabel.isHidden = true
        avatarImageView.isHidden = true
        waitingLabel.isHidden = false
        waitingImageView.isHidden = false
    }
    func allVisible() {
        symtomsLabel.isHidden = false
        cancelButton.isHidden = false
        nameLabel.isHidden = false
        majorLabel.isHidden = false
        priceLabel.isHidden = false
        workLabel.isHidden = false
        graduatedLabel.isHidden = false
        avatarImageView.isHidden = false
        waitingLabel.isHidden = true
        waitingImageView.isHidden = true
    }
}
