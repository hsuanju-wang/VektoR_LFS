using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlugMovement : MonoBehaviour
{
    Rigidbody m_Rigidbody;
    public float m_ThrustX = 2f;
    private bool slugMoving = true;
    // Start is called before the first frame update
    void Start()
    {
        m_Rigidbody = GetComponent<Rigidbody>();
        
    }

    // Update is called once per frame
    void Update()
    {
        if(slugMoving){
            StartCoroutine(SlugMove());
        }
    }

    private IEnumerator SlugMove()
    {
        slugMoving = false;
        m_Rigidbody.AddForce( m_ThrustX, 0, 0, ForceMode.Impulse);
        yield return new WaitForSeconds(2f);
        slugMoving = true;
    }
}
