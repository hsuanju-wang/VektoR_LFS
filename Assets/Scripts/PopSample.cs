using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopSample : MonoBehaviour
{
    Rigidbody m_Rigidbody;
    MeshRenderer m_MeshRenderer;
    public float m_ThrustY = 7f;
    public float m_ThrustX = 1f;
    public GameObject particles;

    // Start is called before the first frame update
    void Start()
    {
        m_Rigidbody = GetComponent<Rigidbody>();
        m_MeshRenderer = GetComponent<MeshRenderer>();

    }

    public void popOut(){
        particles.SetActive(true);
        m_MeshRenderer.enabled = true;
        m_Rigidbody.AddForce( m_ThrustX, m_ThrustY, 0, ForceMode.Impulse);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("space"))
        {
            popOut();
        }
    }

}
