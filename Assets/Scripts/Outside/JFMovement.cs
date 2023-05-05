using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JFMovement : MonoBehaviour
{
    Rigidbody m_Rigidbody;
    public float m_ThrustX = 1f;
    public float m_ThrustY = 1f;
    private bool slugMoving = true;
    public float maxY = 10f;
    public float minY = 5f;
    bool maxCrossed = false;
    // Start is called before the first frame update
    void Start()
    {
        Random.InitState((int)this.name.GetHashCode());
        m_Rigidbody = GetComponent<Rigidbody>();
        m_ThrustX = Random.Range(-0.3f, 0.3f);
        m_ThrustY = Random.Range(0.3f, 0.7f);
    }

    // Update is called once per frame
    void Update()
    {
        if(slugMoving){
            StartCoroutine(SlugMove());
            if (transform.position.y > maxY)
            {
                maxCrossed = true;
            }
            if(transform.position.y < minY)
            {
                maxCrossed = false;
            }
        }
    }

    private IEnumerator SlugMove()
    {
        slugMoving = false;
        if (maxCrossed)
        {
            //Go Down
            m_Rigidbody.AddForce(m_ThrustX, m_ThrustY*-1, 0, ForceMode.Impulse);
        } else
        {
            //Go Up till maxCrossed
            m_Rigidbody.AddForce(m_ThrustX, m_ThrustY, 0, ForceMode.Impulse);
        }
        
        yield return new WaitForSeconds(2f);
        slugMoving = true;
    }
}
