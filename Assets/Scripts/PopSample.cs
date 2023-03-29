using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopSample : MonoBehaviour
{
    Rigidbody m_Rigidbody;
    public float m_Thrust = 20f;

    // Start is called before the first frame update
    void Start()
    {
        m_Rigidbody = GetComponent<Rigidbody>();
        m_Rigidbody.AddForce(transform.up * m_Thrust);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
